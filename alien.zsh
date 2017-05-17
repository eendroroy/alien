#!/usr/bin/env zsh

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
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return false;
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
    _pull=$(git rev-list --left-right --count `_git_branch_name`...origin/`_git_branch_name` | awk '{print $2}' | tr -d ' ');
    _push=$(git rev-list --left-right --count `_git_branch_name`...origin/`_git_branch_name` | awk '{print $1}' | tr -d ' ');
    [[ "$_pull" != "0" ]] && echo -n "⇣ ";
    [[ "$_push" != "0" ]] && echo -n "⇡ ";
  else
    echo -n "";
  fi
}

_vcs_dirty(){
  if [[ $(_is_git) == 1 ]]; then
    _mod=$(git status --porcelain 2>/dev/null | grep M | wc -l | tr -d ' ');
    _add=$(git status --porcelain 2>/dev/null | grep A | wc -l | tr -d ' ');
    _del=$(git status --porcelain 2>/dev/null | grep D | wc -l | tr -d ' ');
    _new=$(git status --porcelain 2>/dev/null | grep '??' | wc -l | tr -d ' ');
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

alien0(){
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
  
  setopt promptsubst
  PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %3~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`_vcs_info`%f%k%K{$color10}%F{$color7}%f%k%K{$color10}%F{$color11} $(_vcs_lr)%f%k%K{$color12}%F{$color10}%f%k%K{$color12}%F{$color13} $(_vcs_dirty)%f%k%F{$color12}%f
%F{$color3}$(__ssh_client)%f%F{$color8}%B❱%b%f '
}

alien_prompts(){
  alien0
}

_colorize()
autoload -U add-zsh-hook
alien_prompts
