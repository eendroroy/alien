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
      printf "\n  --> (WARN) theme %s not found. Loading default ..." "${ALIEN_CUSTOM_THEME_PATH}"
      source "${THEME_DIR}/blue.zsh"
    fi
  fi
  alien_theme
}
