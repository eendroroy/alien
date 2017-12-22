#!/usr/bin/env zsh

alien_is_svn(){
  echo `plib_is_svn`;
}

alien_svn_branch() {
  echo -n " ${ALIEN_HG_SYM}: @`plib_svn_rev` ";
}
