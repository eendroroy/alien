#!/usr/bin/env zsh

if [[ $USE_NERD_FONT = 1 ]]; then
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
