#!/usr/bin/env zsh

alien_venv(){
  __venv="`plib_venv`"
  if [[ ${__venv} != "" ]]; then
    echo -ne "`plib_venv` "
  fi
}
