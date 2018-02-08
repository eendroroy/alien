#!/usr/bin/env zsh

THEME_DIR="${0:A:h}/themes"

alien_load_theme(){
  if [[ -z "${ALIEN_CUSTOM_THEME_PATH}" ]]; then
    if [[ -z "${ALIEN_THEME}" ]]; then
      source "${THEME_DIR}/blue.zsh"
    else
      source "${THEME_DIR}/${ALIEN_THEME}.zsh"
    fi
  else
    if [[ -f "${ALIEN_CUSTOM_THEME_PATH}" ]]; then
      source "${ALIEN_CUSTOM_THEME_PATH}"
    else
      echo "\n  --> (WARN) theme ${ALIEN_CUSTOM_THEME_PATH} not found. Loading default ..."
      source "${THEME_DIR}/blue.zsh"
    fi
  fi
  alien_theme

  [[ -z $color10 ]] && color10=244     # lr bg
  [[ -z $color11 ]] && color11=255     # lr fg
  [[ -z $color12 ]] && color12=253     # dirty copy bg
  [[ -z $color13 ]] && color13=016     # dirty copy fg
  [[ -z $color14 ]] && color14=245     # venv color

  [[ -z "${PLIB_GIT_TRACKED_COLOR}" ]]   && PLIB_GIT_TRACKED_COLOR=27
  [[ -z "${PLIB_GIT_UNTRACKED_COLOR}" ]] && PLIB_GIT_UNTRACKED_COLOR=236
}
