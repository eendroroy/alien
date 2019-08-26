#!/usr/bin/env zsh

alien_is_svn(){
  echo -n "$(plib_is_svn)"
}

alien_svn_branch() {
  echo -n " ${ALIEN_SVN_SYM}: @$(plib_svn_rev) ";
}
