#!/usr/bin/env zsh

alien_is_git(){
  echo -ne `plib_is_git`
}

alien_git_branch_name() {
  echo -n "`plib_git_branch`";
}

alien_git_branch() {
  echo -n "${ALIEN_GIT_SYM} ${ALIEN_BRANCH_SYM} $(alien_git_branch_name)";
  return true;
}

alien_git_lr(){
  echo -ne "`plib_git_left_right`";
}

alien_git_dirty(){
  echo -n "`plib_git_dirty` ";
}

alien_git_stash(){
  __stash=$(plib_git_stash)
  if [[ ${__stash} != "0" ]]; then
    echo -ne " ${ALIEN_GIT_STASH_SYM}{${__stash}}"
  fi
  unset __stash
}
