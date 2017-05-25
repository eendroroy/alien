#!/usr/bin/env zsh

alien_is_svn(){
  if [[ $(svn info 2>/dev/null) != "" ]]; then echo -n 1 ; else echo -n 0 ; fi
}

alien_svn_branch() {
  ref=$(svn info 2>/dev/null | grep Revision | awk '{print $2}') || return false;
  echo -n " S: @${ref} ";
  return true;
}