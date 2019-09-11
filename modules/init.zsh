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
  versions
  newline
  ssh
  venv
  prompt
)

[[ -z $ALIEN_SECTIONS_RIGHT ]] && ALIEN_SECTIONS_RIGHT=()

[[ -z "${ALIEN_SECTIONS_LEFT_SEP_SYM}" ]] && ALIEN_SECTIONS_LEFT_SEP_SYM=''
[[ -z "${ALIEN_SECTIONS_RIGHT_SEP_SYM}" ]] && ALIEN_SECTIONS_RIGHT_SEP_SYM=''

[[ -z "${ALIEN_PROMPT_SYM}" ]] && ALIEN_PROMPT_SYM='❱'
[[ -z "${ALIEN_GIT_STASH_SYM}" ]] && ALIEN_GIT_STASH_SYM='@'

[[ -z "${ALIEN_VERSION_PROMPT_SEP}" ]] && ALIEN_VERSION_PROMPT_SEP=' '

if [[ ${ALIEN_USE_NERD_FONT} = 1 ]]; then
  [[ -z "${ALIEN_GIT_SYM}" ]]      && ALIEN_GIT_SYM=''
  [[ -z "${ALIEN_HG_SYM}" ]]       && ALIEN_HG_SYM=''
  [[ -z "${ALIEN_SSH_SYM}" ]]      && ALIEN_SSH_SYM=''
  [[ -z "${ALIEN_JAVA_SYM}" ]]     && ALIEN_JAVA_SYM=' '
  [[ -z "${ALIEN_PY_SYM}" ]]       && ALIEN_PY_SYM=' '
  [[ -z "${ALIEN_RB_SYM}" ]]       && ALIEN_RB_SYM=' '
  [[ -z "${ALIEN_GO_SYM}" ]]       && ALIEN_GO_SYM='豈'
  [[ -z "${ALIEN_NODE_SYM}" ]]     && ALIEN_NODE_SYM=' '
  [[ -z "${ALIEN_ELIXIR_SYM}" ]]   && ALIEN_ELIXIR_SYM=' '
  [[ -z "${ALIEN_CRYSTAL_SYM}" ]]  && ALIEN_CRYSTAL_SYM='ﲹ '
  [[ -z "${ALIEN_GIT_SYM}" ]]      && ALIEN_GIT_SYM=''
  [[ -z "${ALIEN_GIT_ADD_SYM}" ]]  && ALIEN_GIT_ADD_SYM=''
  [[ -z "${ALIEN_GIT_DEL_SYM}" ]]  && ALIEN_GIT_DEL_SYM=''
  [[ -z "${ALIEN_GIT_MOD_SYM}" ]]  && ALIEN_GIT_MOD_SYM=''
  [[ -z "${ALIEN_GIT_NEW_SYM}" ]]  && ALIEN_GIT_NEW_SYM=''
  [[ -z "${ALIEN_HG_SYM}" ]]       && ALIEN_HG_SYM=''
  [[ -z "${ALIEN_SVN_SYM}" ]]      && ALIEN_SVN_SYM='S'
  [[ -z "${ALIEN_BRANCH_SYM}" ]]   && ALIEN_BRANCH_SYM=''
  [[ -z "${ALIEN_GIT_PUSH_SYM}" ]] && ALIEN_GIT_PUSH_SYM=''
  [[ -z "${ALIEN_GIT_PULL_SYM}" ]] && ALIEN_GIT_PULL_SYM=''
else
  [[ -z "${ALIEN_JAVA_SYM}" ]]     && ALIEN_JAVA_SYM='JAVA:'
  [[ -z "${ALIEN_PY_SYM}" ]]       && ALIEN_PY_SYM='PY:'
  [[ -z "${ALIEN_RB_SYM}" ]]       && ALIEN_RB_SYM='RB:'
  [[ -z "${ALIEN_GO_SYM}" ]]       && ALIEN_GO_SYM='GO:'
  [[ -z "${ALIEN_ELIXIR_SYM}" ]]   && ALIEN_ELIXIR_SYM='EX:'
  [[ -z "${ALIEN_CRYSTAL_SYM}" ]]  && ALIEN_CRYSTAL_SYM='CR:'
  [[ -z "${ALIEN_NODE_SYM}" ]]     && ALIEN_NODE_SYM='⬡ '
  [[ -z "${ALIEN_PHP_SYM}" ]]      && ALIEN_PHP_SYM='PHP:'
  [[ -z "${ALIEN_GIT_SYM}" ]]      && ALIEN_GIT_SYM=G
  [[ -z "${ALIEN_GIT_ADD_SYM}" ]]  && ALIEN_GIT_ADD_SYM='+'
  [[ -z "${ALIEN_GIT_DEL_SYM}" ]]  && ALIEN_GIT_DEL_SYM='-'
  [[ -z "${ALIEN_GIT_MOD_SYM}" ]]  && ALIEN_GIT_MOD_SYM='⭑'
  [[ -z "${ALIEN_GIT_NEW_SYM}" ]]  && ALIEN_GIT_NEW_SYM='?'
  [[ -z "${ALIEN_HG_SYM}" ]]       && ALIEN_HG_SYM=H
  [[ -z "${ALIEN_SVN_SYM}" ]]      && ALIEN_SVN_SYM=S
  [[ -z "${ALIEN_BRANCH_SYM}" ]]   && ALIEN_BRANCH_SYM=''
  [[ -z "${ALIEN_GIT_PUSH_SYM}" ]] && ALIEN_GIT_PUSH_SYM='↑'
  [[ -z "${ALIEN_GIT_PULL_SYM}" ]] && ALIEN_GIT_PULL_SYM='↓'
fi
