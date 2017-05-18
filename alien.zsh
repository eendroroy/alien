#!/usr/bin/env bash

#!/usr/bin/env zsh

#
# zsh-async
#
# version: 1.5.1
# author: Mathias Fredriksson
# url: https://github.com/mafredri/zsh-async
#

# Produce debug output from zsh-async when set to 1.
ASYNC_DEBUG=${ASYNC_DEBUG:-0}

# Wrapper for jobs executed by the async worker, gives output in parseable format with execution time
_async_job() {
  # Disable xtrace as it would mangle the output.
  setopt localoptions noxtrace

  # Store start time for job.
  float -F duration=$EPOCHREALTIME

  # Run the command and capture both stdout (`eval`) and stderr (`cat`) in
  # separate subshells. When the command is complete, we grab write lock
  # (mutex token) and output everything except stderr inside the command
  # block, after the command block has completed, the stdin for `cat` is
  # closed, causing stderr to be appended with a $'\0' at the end to mark the
  # end of output from this job.
  local stdout stderr ret tok
  {
    stdout=$(eval "$@")
    ret=$?
    duration=$(( EPOCHREALTIME - duration ))  # Calculate duration.

    # Grab mutex lock, stalls until token is available.
    read -r -k 1 -p tok || exit 1

    # Return output (<job_name> <return_code> <stdout> <duration> <stderr>).
    print -r -n - ${(q)1} $ret ${(q)stdout} $duration
  } 2> >(stderr=$(cat) && print -r -n - " "${(q)stderr}$'\0')

  # Unlock mutex by inserting a token.
  print -n -p $tok
}

# The background worker manages all tasks and runs them without interfering with other processes
_async_worker() {
  # Reset all options to defaults inside async worker.
  emulate -R zsh

  # Make sure monitor is unset to avoid printing the
  # pids of child processes.
  unsetopt monitor

  # Redirect stderr to `/dev/null` in case unforseen errors produced by the
  # worker. For example: `fork failed: resource temporarily unavailable`.
  # Some older versions of zsh might also print malloc errors (know to happen
  # on at least zsh 5.0.2 and 5.0.8) likely due to kill signals.
  exec 2>/dev/null

  # When a zpty is deleted (using -d) all the zpty instances created before
  # the one being deleted receive a SIGHUP, unless we catch it, the async
  # worker would simply exit (stop working) even though visible in the list
  # of zpty's (zpty -L).
  TRAPHUP() {
    return 0  # Return 0, indicating signal was handled.
  }

  local -A storage
  local unique=0
  local notify_parent=0
  local parent_pid=0
  local coproc_pid=0
  local processing=0

  local -a zsh_hooks zsh_hook_functions
  zsh_hooks=(chpwd periodic precmd preexec zshexit zshaddhistory)
  zsh_hook_functions=(${^zsh_hooks}_functions)
  unfunction $zsh_hooks &>/dev/null   # Deactivate all zsh hooks inside the worker.
  unset $zsh_hook_functions           # And hooks with registered functions.
  unset zsh_hooks zsh_hook_functions  # Cleanup.

  child_exit() {
    local -a pids
    pids=(${${(v)jobstates##*:*:}%\=*})

    # If coproc (cat) is the only child running, we close it to avoid
    # leaving it running indefinitely and cluttering the process tree.
    if  (( ! processing )) && [[ $#pids = 1 ]] && [[ $coproc_pid = $pids[1] ]]; then
      coproc :
      coproc_pid=0
    fi

    # On older version of zsh (pre 5.2) we notify the parent through a
    # SIGWINCH signal because `zpty` did not return a file descriptor (fd)
    # prior to that.
    if (( notify_parent )); then
      # We use SIGWINCH for compatibility with older versions of zsh
      # (pre 5.1.1) where other signals (INFO, ALRM, USR1, etc.) could
      # cause a deadlock in the shell under certain circumstances.
      kill -WINCH $parent_pid
    fi
  }

  # Register a SIGCHLD trap to handle the completion of child processes.
  trap child_exit CHLD

  # Process option parameters passed to worker
  while getopts "np:u" opt; do
    case $opt in
      n) notify_parent=1;;
      p) parent_pid=$OPTARG;;
      u) unique=1;;
    esac
  done

  killjobs() {
    local tok
    local -a pids
    pids=(${${(v)jobstates##*:*:}%\=*})

    # No need to send SIGHUP if no jobs are running.
    (( $#pids == 0 )) && continue
    (( $#pids == 1 )) && [[ $coproc_pid = $pids[1] ]] && continue

    # Grab lock to prevent half-written output in case a child
    # process is in the middle of writing to stdin during kill.
    (( coproc_pid )) && read -r -k 1 -p tok

    kill -HUP -$$  # Send to entire process group.
    coproc :       # Quit coproc.
    coproc_pid=0   # Reset pid.
  }

  local request
  local -a cmd
  while :; do
    # Wait for jobs sent by async_job.
    read -r -d $'\0' request || {
      # Since we handle SIGHUP above (and thus do not know when `zpty -d`)
      # occurs, a failure to read probably indicates that stdin has
      # closed. This is why we propagate the signal to all children and
      # exit manually.
      kill -HUP -$$  # Send SIGHUP to all jobs.
      exit 0
    }

    # Check for non-job commands sent to worker
    case $request in
      _unset_trap) notify_parent=0; continue;;
      _killjobs)   killjobs; continue;;
    esac

    # Parse the request using shell parsing (z) to allow commands
    # to be parsed from single strings and multi-args alike.
    cmd=("${(z)request}")

    # Name of the job (first argument).
    local job=$cmd[1]

    # If worker should perform unique jobs
    if (( unique )); then
      # Check if a previous job is still running, if yes, let it finnish
      for pid in ${${(v)jobstates##*:*:}%\=*}; do
        if [[ ${storage[$job]} == $pid ]]; then
          continue 2
        fi
      done
    fi

    # Guard against closing coproc from trap before command has started.
    processing=1

    # Because we close the coproc after the last job has completed, we must
    # recreate it when there are no other jobs running.
    if (( ! coproc_pid )); then
      # Use coproc as a mutex for synchronized output between children.
      coproc cat
      coproc_pid="$!"
      # Insert token into coproc
      print -n -p "t"
    fi

    # Run job in background, completed jobs are printed to stdout.
    _async_job $cmd &
    # Store pid because zsh job manager is extremely unflexible (show jobname as non-unique '$job')...
    storage[$job]="$!"

    processing=0  # Disable guard.
  done
}

#
#  Get results from finnished jobs and pass it to the to callback function. This is the only way to reliably return the
#  job name, return code, output and execution time and with minimal effort.
#
# usage:
#   async_process_results <worker_name> <callback_function>
#
# callback_function is called with the following parameters:
#   $1 = job name, e.g. the function passed to async_job
#   $2 = return code
#   $3 = resulting stdout from execution
#   $4 = execution time, floating point e.g. 2.05 seconds
#   $5 = resulting stderr from execution
#
async_process_results() {
  setopt localoptions noshwordsplit

  local worker=$1
  local callback=$2
  local caller=$3
  local -a items
  local null=$'\0' data
  integer -l len pos num_processed

  typeset -gA ASYNC_PROCESS_BUFFER

  # Read output from zpty and parse it if available.
  while zpty -r -t $worker data 2>/dev/null; do
    ASYNC_PROCESS_BUFFER[$worker]+=$data
    len=${#ASYNC_PROCESS_BUFFER[$worker]}
    pos=${ASYNC_PROCESS_BUFFER[$worker][(i)$null]}  # Get index of NULL-character (delimiter).

    # Keep going until we find a NULL-character.
    if (( ! len )) || (( pos > len )); then
      continue
    fi

    while (( pos <= len )); do
      # Take the content from the beginning, until the NULL-character and
      # perform shell parsing (z) and unquoting (Q) as an array (@).
      items=("${(@Q)${(z)ASYNC_PROCESS_BUFFER[$worker][1,$pos-1]}}")

      # Remove the extracted items from the buffer.
      ASYNC_PROCESS_BUFFER[$worker]=${ASYNC_PROCESS_BUFFER[$worker][$pos+1,$len]}

      if (( $#items == 5 )); then
        $callback "${(@)items}"  # Send all parsed items to the callback.
      else
        # In case of corrupt data, invoke callback with *async* as job
        # name, non-zero exit status and an error message on stderr.
        $callback "async" 1 "" 0 "$0:$LINENO: error: bad format, got ${#items} items (${(@q)items})"
      fi

      (( num_processed++ ))

      len=${#ASYNC_PROCESS_BUFFER[$worker]}
      if (( len > 1 )); then
        pos=${ASYNC_PROCESS_BUFFER[$worker][(i)$null]}  # Get index of NULL-character (delimiter).
      fi
    done
  done

  (( num_processed )) && return 0

  # Avoid printing exit value when `setopt printexitvalue` is active.`
  [[ $caller = trap || $caller = watcher ]] && return 0

  # No results were processed
  return 1
}

# Watch worker for output
_async_zle_watcher() {
  setopt localoptions noshwordsplit
  typeset -gA ASYNC_PTYS ASYNC_CALLBACKS
  local worker=$ASYNC_PTYS[$1]
  local callback=$ASYNC_CALLBACKS[$worker]

  if [[ -n $callback ]]; then
    async_process_results $worker $callback watcher
  fi
}

#
# Start a new asynchronous job on specified worker, assumes the worker is running.
#
# usage:
#   async_job <worker_name> <my_function> [<function_params>]
#
async_job() {
  setopt localoptions noshwordsplit

  local worker=$1; shift

  local -a cmd
  cmd=("$@")
  if (( $#cmd > 1 )); then
    cmd=(${(q)cmd})  # Quote special characters in multi argument commands.
  fi

  # Quote the cmd in case RC_EXPAND_PARAM is set.
  zpty -w $worker "$cmd"$'\0'
}

# This function traps notification signals and calls all registered callbacks
_async_notify_trap() {
  setopt localoptions noshwordsplit

  for k in ${(k)ASYNC_CALLBACKS}; do
    async_process_results $k ${ASYNC_CALLBACKS[$k]} trap
  done
}

#
# Register a callback for completed jobs. As soon as a job is finnished, async_process_results will be called with the
# specified callback function. This requires that a worker is initialized with the -n (notify) option.
#
# usage:
#   async_register_callback <worker_name> <callback_function>
#
async_register_callback() {
  setopt localoptions noshwordsplit nolocaltraps

  typeset -gA ASYNC_CALLBACKS
  local worker=$1; shift

  ASYNC_CALLBACKS[$worker]="$*"

  # Enable trap when the ZLE watcher is unavailable, allows
  # workers to notify (via -n) when a job is done.
  if [[ ! -o interactive ]] || [[ ! -o zle ]]; then
    trap '_async_notify_trap' WINCH
  fi
}

#
# Unregister the callback for a specific worker.
#
# usage:
#   async_unregister_callback <worker_name>
#
async_unregister_callback() {
  typeset -gA ASYNC_CALLBACKS

  unset "ASYNC_CALLBACKS[$1]"
}

#
# Flush all current jobs running on a worker. This will terminate any and all running processes under the worker, use
# with caution.
#
# usage:
#   async_flush_jobs <worker_name>
#
async_flush_jobs() {
  setopt localoptions noshwordsplit

  local worker=$1; shift

  # Check if the worker exists
  zpty -t $worker &>/dev/null || return 1

  # Send kill command to worker
  async_job $worker "_killjobs"

  # Clear the zpty buffer.
  local junk
  if zpty -r -t $worker junk '*'; then
    (( ASYNC_DEBUG )) && print -n "async_flush_jobs $worker: ${(V)junk}"
    while zpty -r -t $worker junk '*'; do
      (( ASYNC_DEBUG )) && print -n "${(V)junk}"
    done
    (( ASYNC_DEBUG )) && print
  fi

  # Finally, clear the process buffer in case of partially parsed responses.
  typeset -gA ASYNC_PROCESS_BUFFER
  unset "ASYNC_PROCESS_BUFFER[$worker]"
}

#
# Start a new async worker with optional parameters, a worker can be told to only run unique tasks and to notify a
# process when tasks are complete.
#
# usage:
#   async_start_worker <worker_name> [-u] [-n] [-p <pid>]
#
# opts:
#   -u unique (only unique job names can run)
#   -n notify through SIGWINCH signal
#   -p pid to notify (defaults to current pid)
#
async_start_worker() {
  setopt localoptions noshwordsplit

  local worker=$1; shift
  zpty -t $worker &>/dev/null && return

  typeset -gA ASYNC_PTYS
  typeset -h REPLY
  typeset has_xtrace=0

  # Make sure async worker is started without xtrace
  # (the trace output interferes with the worker).
  [[ -o xtrace ]] && {
    has_xtrace=1
    unsetopt xtrace
  }

  if (( ! ASYNC_ZPTY_RETURNS_FD )) && [[ -o interactive ]] && [[ -o zle ]]; then
    # When zpty doesn't return a file descriptor (on older versions of zsh)
    # we try to guess it anyway.
    integer -l zptyfd
    exec {zptyfd}>&1  # Open a new file descriptor (above 10).
    exec {zptyfd}>&-  # Close it so it's free to be used by zpty.
  fi

  zpty -b $worker _async_worker -p $$ $@ || {
    async_stop_worker $worker
    return 1
  }

  # Re-enable it if it was enabled, for debugging.
  (( has_xtrace )) && setopt xtrace

  if [[ $ZSH_VERSION < 5.0.8 ]]; then
    # For ZSH versions older than 5.0.8 we delay a bit to give
    # time for the worker to start before issuing commands,
    # otherwise it will not be ready to receive them.
    sleep 0.001
  fi

  if [[ -o interactive ]] && [[ -o zle ]]; then
    if (( ! ASYNC_ZPTY_RETURNS_FD )); then
      REPLY=$zptyfd  # Use the guessed value for the file desciptor.
    fi

    ASYNC_PTYS[$REPLY]=$worker        # Map the file desciptor to the worker.
    zle -F $REPLY _async_zle_watcher  # Register the ZLE handler.

    # Disable trap in favor of ZLE handler when notify is enabled (-n).
    async_job $worker _unset_trap
  fi
}

#
# Stop one or multiple workers that are running, all unfetched and incomplete work will be lost.
#
# usage:
#   async_stop_worker <worker_name_1> [<worker_name_2>]
#
async_stop_worker() {
  setopt localoptions noshwordsplit

  local ret=0
  for worker in $@; do
    # Find and unregister the zle handler for the worker
    for k v in ${(@kv)ASYNC_PTYS}; do
      if [[ $v == $worker ]]; then
        zle -F $k
        unset "ASYNC_PTYS[$k]"
      fi
    done
    async_unregister_callback $worker
    zpty -d $worker 2>/dev/null || ret=$?

    # Clear any partial buffers.
    typeset -gA ASYNC_PROCESS_BUFFER
    unset "ASYNC_PROCESS_BUFFER[$worker]"
  done

  return $ret
}

#
# Initialize the required modules for zsh-async. To be called before using the zsh-async library.
#
# usage:
#   async_init
#
async_init() {
  (( ASYNC_INIT_DONE )) && return
  ASYNC_INIT_DONE=1

  zmodload zsh/zpty
  zmodload zsh/datetime

  # Check if zsh/zpty returns a file descriptor or not,
  # shell must also be interactive with zle enabled.
  ASYNC_ZPTY_RETURNS_FD=0
  [[ -o interactive ]] && [[ -o zle ]] && {
    typeset -h REPLY
    zpty _async_test :
    (( REPLY )) && ASYNC_ZPTY_RETURNS_FD=1
    zpty -d _async_test
  }
}

async() {
  async_init
}

async "$@"

_zsh_terminal_set_256color() {
  if [[ "$TERM" =~ "-256color$" ]] ; then
    [[ -n "${ZSH_256COLOR_DEBUG}" ]] && echo -n "zsh-256color: 256 color terminal already set." >&2
    return
  fi

  local TERM256="${TERM}-256color"

  # Use (n-)curses binaries, if installed.
  if [[ -x "$( which toe )" ]] ; then
    if toe -a | egrep -q "^$TERM256" ; then
      _zsh_256color_debug "Found $TERM256 from (n-)curses binaries."
      export TERM="$TERM256"
      return
    fi
  fi

  # Search through termcap descriptions, if binaries are not installed.
  for termcaps in $TERMCAP "$HOME/.termcap" "/etc/termcap" "/etc/termcap.small" ; do
    if [[ -e "$termcaps" ]] && egrep -q "(^$TERM256|\|$TERM256)\|" "$termcaps" ; then
      _zsh_256color_debug "Found $TERM256 from $termcaps."
      export TERM="$TERM256"
      return
    fi
  done

  # Search through terminfo descriptions, if binaries are not installed.
  for terminfos in $TERMINFO "$HOME/.terminfo" "/etc/terminfo" "/lib/terminfo" "/usr/share/terminfo" ; do
    if [[ -e "$terminfos"/$TERM[1]/"$TERM256" || \
        -e "$terminfos"/"$TERM256" ]] ; then
      _zsh_256color_debug "Found $TERM256 from $terminfos."
      export TERM="$TERM256"
      return
    fi
  done
}

_colorize(){
  _zsh_terminal_set_256color
  unset -f _zsh_terminal_set_256color
}

_is_svn(){
  if [[ $(svn info 2>/dev/null) != "" ]]; then echo -n 1 ; else echo -n 0 ; fi
}

_svn_branch() {
  ref=$(svn info 2>/dev/null | grep Revision | awk '{print $2}') || return false;
  echo -n " SVN: @${ref} ";
  return true;
}

_is_git(){
  if [[ $(git branch 2>/dev/null) != "" ]]; then echo -n 1 ; else echo -n 0 ; fi
}

_git_branch_name() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref="detached" || return false;
  echo -n "${ref#refs/heads/}";
  return true;
}

_git_branch() {
  echo -n " GIT:  $(_git_branch_name) ";
  return true;
}

_is_hg(){
  if [[ $(hg branch 2>/dev/null) != "" ]]; then echo -n 1 ; else echo -n 0 ; fi
}

_hg_branch() {
  ref=$(hg branch 2> /dev/null) || return true;
  echo -n " HG:  ${ref} ";
  return true;
}

_vcs_info(){
  if [[ $(_is_git) == 1 ]]; then
    _git_branch;
  elif [[ $(_is_hg) == 1 ]]; then
    _hg_branch;
  elif [[ $(_is_svn) == 1 ]]; then
    _svn_branch;
  else
    echo -n " ";
  fi
}

_vcs_lr(){
  if [[ $(_is_git) == 1 ]]; then
    if [[ 4(_git_branch_name) != "detached" ]]; then
      _pull=$(git rev-list --left-right --count `_git_branch_name`...origin/`_git_branch_name` | awk '{print $2}' | tr -d ' ');
      _push=$(git rev-list --left-right --count `_git_branch_name`...origin/`_git_branch_name` | awk '{print $1}' | tr -d ' ');
      [[ "$_pull" != "0" ]] && echo -n "⇣ ";
      [[ "$_push" != "0" ]] && echo -n "⇡ ";
    fi
  else
    echo -n "";
  fi
}

_vcs_dirty(){
  if [[ $(_is_git) == 1 ]]; then
    _mod=$(git status --porcelain 2>/dev/null | grep 'M ' | wc -l | tr -d ' ');
    _add=$(git status --porcelain 2>/dev/null | grep 'A ' | wc -l | tr -d ' ');
    _del=$(git status --porcelain 2>/dev/null | grep 'D ' | wc -l | tr -d ' ');
    _new=$(git status --porcelain 2>/dev/null | grep '?? ' | wc -l | tr -d ' ');
    [[ "$_mod" != "0" ]] && echo -n "⭑ ";
    [[ "$_add" != "0" ]] && echo -n "+ ";
    [[ "$_del" != "0" ]] && echo -n "- ";
    [[ "$_new" != "0" ]] && echo -n "? ";
  else
    echo -n "";
  fi
}

__storage_info(){
  fs=`df -h . | tail -1 | awk '{print $1}' | sed "s|\.|•|g" `;
  size=`df -h . | tail -1 | awk '{print $2}' | sed "s|\.|•|g" `;
  used=`df -h . | tail -1 | awk '{print $3}' | sed "s|\.|•|g" `;
  usedp=`df -h . | tail -1 | awk '{print $5}' | sed "s|\.|•|g" `;
  free=`df -h . | tail -1 | awk '{print $4}' | sed "s|\.|•|g" `;
  echo -n "💾 $fs - F:$free U:$used T:$size";
}
__date_time_info(){
  echo -n "`date +%r`";
}

__ssh_client(){
  if [ -n "$SSH_CLIENT" ]; then
    echo -n $SSH_CLIENT | awk {'print $1 " "'};
  fi
}

__battery_stat(){
  __os=`uname`;
  if [[ $__os = "Linux" ]]; then
    if which upower > /dev/null ; then
      __bat_power=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}'`;
      __bat_power_ind="";
      if [[ $__bat_power = "charging" ]]; then __bat_power_ind="+";
      elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="-";
      elif [[ $__bat_power = "fully-charged" ]]; then __bat_power_ind="•";
      fi
      __bat_per=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | sed "s|%||g"`;
      if [[ -n $__bat_per ]]; then
        echo -n " | ${__bat_power_ind}${__bat_per}";
      fi
    fi
  fi
  if [[ $__os = "Darwin" ]]; then
    __bat_power=`pmset -g batt | tail -1 | awk '{print $4}' | tr -d "%;"`;
    __bat_power_ind="";
    if [[ $__bat_power = "charging" ]]; then __bat_power_ind="+";
    elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="-";
    elif [[ $__bat_power = "finishing" ]]; then __bat_power_ind="+";
    elif [[ $__bat_power = "charged" ]]; then __bat_power_ind="•";
    fi
       __bat_per=`pmset -g batt | tail -1 | awk '{print $3}' | tr -d "%;"`
    if [[ -n $__bat_per ]]; then
      echo -n " | ${__bat_power_ind}${__bat_per}";
    fi
  fi
}

function __dummy(){}

function __lprompt_complete() {
  if [[ $(_is_git) == 1 ]]; then
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %3~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`_vcs_info`%f%k%K{$color10}%F{$color7}%f%k%K{$color10}%F{$color11} $(_vcs_lr)%f%k%K{$color12}%F{$color10}%f%k%K{$color12}%F{$color13} $(_vcs_dirty)%f%k%F{$color12}%f
%F{$color3}$(__ssh_client)%f%F{$color8}%B❱%b%f '
  elif [[ $(_is_hg) == 1 ]]; then
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %3~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`_vcs_info`%f%k%K{$color10}%F{$color7}%f%k%K{$color10}%F{$color11} $(_vcs_lr)%f%k%K{$color12}%F{$color10}%f%k%K{$color12}%F{$color13} $(_vcs_dirty)%f%k%F{$color12}%f
%F{$color3}$(__ssh_client)%f%F{$color8}%B❱%b%f '
  elif [[ $(_is_svn) == 1 ]]; then
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %3~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`_vcs_info`%f%k%K{$color10}%F{$color7}%f%k%K{$color10}%F{$color11} $(_vcs_lr)%f%k%K{$color12}%F{$color10}%f%k%K{$color12}%F{$color13} $(_vcs_dirty)%f%k%F{$color12}%f
%F{$color3}$(__ssh_client)%f%F{$color8}%B❱%b%f '
  else
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %3~ %f%k%F{$color5}%f
%F{$color3}$(__ssh_client)%f%F{$color8}%B❱%b%f '
  fi
  zle && zle reset-prompt
  async_stop_worker lprompt -n
}

function precmd(){
  _colorize()
  autoload -U add-zsh-hook
  setopt prompt_subst

  if [[ $ALIEN_THEME == "red" ]]; then
    color0=088    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=202    # user bg
    color4=232    # user fg
    color5=214    # dir bg
    color6=232    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=226    # vcs fg
  elif [[ $ALIEN_THEME == "green" ]]; then
    color0=022    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=034    # user bg
    color4=232    # user fg
    color5=082    # dir bg
    color6=232    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=154    # vcs fg
  elif [[ $ALIEN_THEME == "blue" ]]; then
    color0=018    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=026    # user bg
    color4=254    # user fg
    color5=045    # dir bg
    color6=019    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=051    # vcs fg
  else
    color0=018    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=026    # user bg
    color4=254    # user fg
    color5=045    # dir bg
    color6=019    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=051    # vcs fg
  fi
  color10=245     # lr bg
  color11=255     # lr fg
  color12=253     # dirty copy bg
  color13=016     # dirty copy fg

  RPROMPT=''
  if [[ $DEFAULT_USER == $USER ]]; then
    _user=''
  else
    _user=`whoami`
  fi
  
  PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %3~ %f%k%F{$color5}%f
%F{$color3}$(__ssh_client)%f%F{$color8}%B❱%b%f '
  async_init
  async_start_worker lprompt -n
  async_register_callback lprompt __lprompt_complete
  async_job lprompt __dummy
}
