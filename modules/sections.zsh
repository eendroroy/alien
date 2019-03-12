#!/usr/bin/env zsh

alien_prompt_section_exit() {
  __section=(
    content "%(?.. %? )"
    foreground $ALIEN_SECTION_EXIT_FG
    background "%(?.$ALIEN_SECTION_EXIT_BG.$ALIEN_SECTION_EXIT_BG_ERROR)"
    separator 1
  )
}

alien_prompt_section_time() {
  __section=(
    content " $(alien_time_info) "
    foreground $ALIEN_SECTION_TIME_FG
    background $ALIEN_SECTION_TIME_BG
    separator 1
  )
}

alien_prompt_section_battery() {
  __section=(
    content " $(alien_battery_stat) "
    foreground $ALIEN_SECTION_BATTERY_FG
    background $ALIEN_SECTION_BATTERY_BG
    separator 1
  )
}

alien_prompt_section_user() {
  __section=(
    content " $(alien_user_info) "
    foreground $ALIEN_SECTION_USER_FG
    background $ALIEN_SECTION_USER_BG
    separator 1
  )
}

alien_prompt_section_path() {
  local __path_info=
  if [[ -z $ALIEN_SECTION_PATH_COMPONENTS ]]; then
    __path_info="%~"
  else
    __path_info="%${ALIEN_SECTION_PATH_COMPONENTS}~"
  fi
  __section=(
    content " ${__path_info} "
    foreground $ALIEN_SECTION_PATH_FG
    background $ALIEN_SECTION_PATH_BG
    separator 1
  )
}

alien_prompt_section_vcs_branch() {
  local __branch_info=
  if [[ $(alien_is_git) == 1 ]]; then
    __branch_info=$(alien_git_branch)
  elif [[ $(alien_is_hg) == 1 ]]; then
    __branch_info=$(alien_hg_branch)
  elif [[ $(alien_is_svn) == 1 ]]; then
    __branch_info=$(alien_svn_branch)
  else
    return 1
  fi
  __section=(
    content " ${__branch_info} "
    foreground $ALIEN_SECTION_VCS_BRANCH_FG
    background $ALIEN_SECTION_VCS_BRANCH_BG
    separator 1
  )
}

alien_prompt_section_vcs_status() {
  local __stash_info=
  local __lr_info=
  if [[ $(alien_is_git) == 1 ]]; then
    __stash_info=$(alien_git_stash)
    __lr_info=$(alien_git_lr)
  else
    return 1
  fi
  __section=(
    content "${__stash_info}${__lr_info}"
    foreground $ALIEN_SECTION_VCS_STATUS_FG
    background $ALIEN_SECTION_VCS_STATUS_BG
    separator 1
  )
}

alien_prompt_section_vcs_dirty() {
  local __dirty_info=
  if [[ $(alien_is_git) == 1 ]]; then
    __dirty_info=$(alien_git_dirty)
  else
    return 1
  fi
  __section=(
    content "${__dirty_info}"
    foreground $ALIEN_SECTION_VCS_DIRTY_FG
    background $ALIEN_SECTION_VCS_DIRTY_BG
    separator 1
  )
}

alien_prompt_section_newline() {
  __section=(
    content $'\n'
  )
}

alien_prompt_section_ssh() {
  local __ssh_info=$(alien_ssh_client)
  [[ -n $__ssh_info ]] || return 1
  __section=(
    content "${__ssh_info}"
    foreground $ALIEN_SECTION_SSH_FG
  )
}

alien_prompt_section_venv() {
  local __venv_info=$(alien_venv)
  [[ -n $__venv_info ]] || return 1
  __section=(
    content "(${__venv_info}) "
    foreground $ALIEN_SECTION_VENV_FG
  )
}

alien_prompt_section_prompt() {
  __section=(
    content "%B${ALIEN_PROMPT_SYM}%b "
    foreground $ALIEN_PROMPT_FG
  )
}
