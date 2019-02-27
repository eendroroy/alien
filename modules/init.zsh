#!/usr/bin/env zsh

[[ -z $ALIEN_SECTIONS_LEFT ]] && ALIEN_SECTIONS_LEFT=(
  exit
  time
  battery
  user
  path
  vcs_branch:async
  vcs_status:async
  vcs_dirty:async
  newline
  ssh
  venv
  prompt
)

[[ -z $ALIEN_SECTIONS_RIGHT ]] && ALIEN_SECTIONS_RIGHT=()

[[ -z "${ALIEN_SECTIONS_LEFT_SEP_SYM}" ]] && ALIEN_SECTIONS_LEFT_SEP_SYM=
[[ -z "${ALIEN_SECTIONS_RIGHT_SEP_SYM}" ]] && ALIEN_SECTIONS_RIGHT_SEP_SYM=

[[ -z "${ALIEN_PROMPT_SYM}" ]] && ALIEN_PROMPT_SYM=❱
[[ -z "${ALIEN_GIT_STASH_SYM}" ]] && ALIEN_GIT_STASH_SYM='@'

if [[ ${USE_NERD_FONT} = 1 ]]; then
  [[ -z "${ALIEN_GIT_SYM}" ]]     && ALIEN_GIT_SYM=
  [[ -z "${PLIB_GIT_ADD_SYM}" ]]  && PLIB_GIT_ADD_SYM=
  [[ -z "${PLIB_GIT_DEL_SYM}" ]]  && PLIB_GIT_DEL_SYM=
  [[ -z "${PLIB_GIT_MOD_SYM}" ]]  && PLIB_GIT_MOD_SYM=
  [[ -z "${PLIB_GIT_NEW_SYM}" ]]  && PLIB_GIT_NEW_SYM=
  [[ -z "${PLIB_GIT_PUSH_SYM}" ]] && PLIB_GIT_PUSH_SYM=
  [[ -z "${PLIB_GIT_PULL_SYM}" ]] && PLIB_GIT_PULL_SYM=
  [[ -z "${ALIEN_HG_SYM}" ]]      && ALIEN_HG_SYM=
  [[ -z "${ALIEN_BRANCH_SYM}" ]]  && ALIEN_BRANCH_SYM=
fi

[[ -z "${ALIEN_GIT_SYM}" ]]     && ALIEN_GIT_SYM=G
[[ -z "${ALIEN_HG_SYM}" ]]      && ALIEN_HG_SYM=H
[[ -z "${ALIEN_SVN_SYM}" ]]     && ALIEN_SVN_SYM=S
[[ -z "${ALIEN_BRANCH_SYM}" ]]  && ALIEN_BRANCH_SYM=
[[ -z "${PLIB_GIT_PUSH_SYM}" ]] && PLIB_GIT_PUSH_SYM=↑
[[ -z "${PLIB_GIT_PULL_SYM}" ]] && PLIB_GIT_PULL_SYM=↓
