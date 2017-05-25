#!/usr/bin/env zsh

alien_is_hg(){
  if [[ $(hg branch 2>/dev/null) != "" ]]; then echo -n 1 ; else echo -n 0 ; fi
}

alien_hg_branch() {
  ref=$(hg branch 2> /dev/null) || return true;
  echo -n " H:  ${ref} ";
  return true;
}