#!/usr/bin/env zsh

if [[ $USE_NERD_FONT = 1 ]]; then
  [[ -z "${AM_GIT_SYM}" ]]        && AM_GIT_SYM=
  [[ -z "${PLIB_GIT_ADD_SYM}" ]]  && PLIB_GIT_ADD_SYM=
  [[ -z "${PLIB_GIT_DEL_SYM}" ]]  && PLIB_GIT_DEL_SYM=
  [[ -z "${PLIB_GIT_MOD_SYM}" ]]  && PLIB_GIT_MOD_SYM=
  [[ -z "${PLIB_GIT_NEW_SYM}" ]]  && PLIB_GIT_NEW_SYM=
  [[ -z "${PLIB_GIT_PUSH_SYM}" ]] && PLIB_GIT_PUSH_SYM=
  [[ -z "${PLIB_GIT_PULL_SYM}" ]] && PLIB_GIT_PULL_SYM=
  [[ -z "${AM_HG_SYM}" ]]         && AM_HG_SYM=
fi

[[ -z "${AM_GIT_SYM}" ]] && AM_GIT_SYM=G
[[ -z "${AM_HG_SYM}" ]]  && AM_HG_SYM=H
[[ -z "${AM_SVN_SYM}" ]] && AM_SVN_SYM=S

[[ -z "${PLIB_GIT_PUSH_SYM}" ]] && PLIB_GIT_PUSH_SYM=↑
[[ -z "${PLIB_GIT_PULL_SYM}" ]] && PLIB_GIT_PULL_SYM=↓

if [[ "${ALIEN_THEME}" == "red" ]]; then
  [[ -z "${PLIB_GIT_TRACKED_COLOR}" ]]   && PLIB_GIT_TRACKED_COLOR=124
  [[ -z "${PLIB_GIT_UNTRACKED_COLOR}" ]] && PLIB_GIT_UNTRACKED_COLOR=236
elif [[ "${ALIEN_THEME}" == "green" ]]; then
  [[ -z "${PLIB_GIT_TRACKED_COLOR}" ]]   && PLIB_GIT_TRACKED_COLOR=64
  [[ -z "${PLIB_GIT_UNTRACKED_COLOR}" ]] && PLIB_GIT_UNTRACKED_COLOR=236
elif [[ "${ALIEN_THEME}" == "blue" ]]; then
  [[ -z "${PLIB_GIT_TRACKED_COLOR}" ]]   && PLIB_GIT_TRACKED_COLOR=27
  [[ -z "${PLIB_GIT_UNTRACKED_COLOR}" ]] && PLIB_GIT_UNTRACKED_COLOR=236
else
  [[ -z "${PLIB_GIT_TRACKED_COLOR}" ]]   && PLIB_GIT_TRACKED_COLOR=27
  [[ -z "${PLIB_GIT_UNTRACKED_COLOR}" ]] && PLIB_GIT_UNTRACKED_COLOR=236
fi