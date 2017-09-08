#!/usr/bin/env zsh

THEME_ROOT=${0:A:h}

source "${THEME_ROOT}/libs/promptlib/activate"
source "${THEME_ROOT}/libs/zsh-async/async.zsh"
source "${THEME_ROOT}/libs/zsh-256color/zsh-256color.plugin.zsh"

source "${THEME_ROOT}/modules/colors.zsh"

source "${THEME_ROOT}/modules/system.zsh"
source "${THEME_ROOT}/modules/git.zsh"
source "${THEME_ROOT}/modules/hg.zsh"
source "${THEME_ROOT}/modules/svn.zsh"
source "${THEME_ROOT}/modules/async.zsh"
source "${THEME_ROOT}/modules/python.zsh"

function precmd(){
  autoload -U add-zsh-hook
  setopt prompt_subst

  RPROMPT=''
  if [[ "${DEFAULT_USER}" == "${USER}" ]]; then
    _user=''
  else
    _user=`whoami`
  fi
  
  PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(alien_date_time_info)$(alien_battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %~ %f%k%F{$color5}%f
%F{$color3}$(alien_ssh_client)%f%F{$color14}`alien_venv`%f%F{$color8}%B❱%b%f '
  alien_async_prompt
}
