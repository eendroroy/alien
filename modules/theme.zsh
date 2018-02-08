#!/usr/bin/env zsh

THEME_DIR="${0:A:h}/themes"

alien_load_theme(){
  if [[ -z "${ALIEN_THEME}" ]]; then
    source "${THEME_DIR}/blue.zsh"
  else
    source "${THEME_DIR}/${ALIEN_THEME}.zsh"
  fi
  alien_theme

  [[ -z $color10 ]] && color10=244     # lr bg
  [[ -z $color11 ]] && color11=255     # lr fg
  [[ -z $color12 ]] && color12=253     # dirty copy bg
  [[ -z $color13 ]] && color13=016     # dirty copy fg
  [[ -z $color14 ]] && color14=245     # venv color
}
