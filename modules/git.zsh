#!/usr/bin/env zsh

alien_is_git(){
  echo -ne "$(plib_is_git)"
}

alien_git_branch_name() {
  echo -n "$(plib_git_branch)";
}

alien_git_branch() {
  echo -n "${ALIEN_GIT_SYM} ${ALIEN_BRANCH_SYM} $(alien_git_branch_name)"
}

alien_git_lr(){
  [[ -z "${ALIEN_GIT_PUSH_SYM}" ]] && ALIEN_GIT_PUSH_SYM='↑'
  [[ -z "${ALIEN_GIT_PULL_SYM}" ]] && ALIEN_GIT_PULL_SYM='↓'

  __git_left_right=$(plib_git_left_right)

  __pull=$(echo "$__git_left_right" | awk '{print $2}' | tr -d ' \n')
  __push=$(echo "$__git_left_right" | awk '{print $1}' | tr -d ' \n')

  [[ "$__pull" != 0 ]] && [[ "$__pull" != '' ]] && __pushpull="${__pull}${ALIEN_GIT_PULL_SYM}"
  [[ -n "$__pushpull" ]] && __pushpull+=' '
  [[ "$__push" != 0 ]] && [[ "$__push" != '' ]] && __pushpull+="${__push}${ALIEN_GIT_PUSH_SYM}"

  if [[ "$__pushpull" != '' ]]; then
    echo -ne " ${__pushpull}"
  fi
}

alien_git_dirty(){
  [[ -z "${ALIEN_GIT_TRACKED_COLOR}" ]]    && ALIEN_GIT_TRACKED_COLOR=green
  [[ -z "${ALIEN_GIT_UN_TRACKED_COLOR}" ]] && ALIEN_GIT_UN_TRACKED_COLOR=red

  __git_status=$(plib_git_status)

  __mod_t=$(plib_git_staged_mod "$__git_status")
  __add_t=$(plib_git_staged_add "$__git_status")
  __del_t=$(plib_git_staged_del "$__git_status")

  __mod_ut=$(plib_git_unstaged_mod "$__git_status")
  __add_ut=$(plib_git_unstaged_add "$__git_status")
  __del_ut=$(plib_git_unstaged_del "$__git_status")

  __new=$(plib_git_status_new "$__git_status")

  DIRTY=''
  [[ "$__add_t" != "0" ]]  && DIRTY+="%F{$ALIEN_GIT_TRACKED_COLOR}${ALIEN_GIT_ADD_SYM}%f "
  [[ "$__add_ut" != "0" ]] && DIRTY+="%F{$ALIEN_GIT_UN_TRACKED_COLOR}${ALIEN_GIT_ADD_SYM}%f "
  [[ "$__mod_t" != "0" ]]  && DIRTY+="%F{$ALIEN_GIT_TRACKED_COLOR}${ALIEN_GIT_MOD_SYM}%f "
  [[ "$__mod_ut" != "0" ]] && DIRTY+="%F{$ALIEN_GIT_UN_TRACKED_COLOR}${ALIEN_GIT_MOD_SYM}%f "
  [[ "$__del_t" != "0" ]]  && DIRTY+="%F{$ALIEN_GIT_TRACKED_COLOR}${ALIEN_GIT_DEL_SYM}%f "
  [[ "$__del_ut" != "0" ]] && DIRTY+="%F{$ALIEN_GIT_UN_TRACKED_COLOR}${ALIEN_GIT_DEL_SYM}%f "
  [[ "$__new" != "0" ]]    && DIRTY+="%F{$ALIEN_GIT_UN_TRACKED_COLOR}${ALIEN_GIT_NEW_SYM}%f "

  echo " ${DIRTY}"

  unset __mod_ut __new_ut __add_ut __mod_t __new_t __add_t __del DIRTY
}

alien_git_stash(){
  __stash=$(plib_git_stash)
  if [[ ${__stash} != "0" ]]; then
    echo -ne " ${ALIEN_GIT_STASH_SYM}${__stash} "
  fi
  unset __stash
}
