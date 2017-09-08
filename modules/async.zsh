#!/usr/bin/env zsh

function alien_dummy(){}

function alien_lprompt_complete() {
  if [[ $(alien_is_git) == 1 ]]; then
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(alien_date_time_info)$(alien_battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %1~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`alien_git_branch`%f%k%K{$color10}%F{$color7}%f%k%K{$color10}%F{$color11}$(alien_git_lr) %f%k%K{$color12}%F{$color10}%f%k%K{$color12}%F{$color13}$(alien_git_dirty) %f%k%F{$color12}%f
%F{$color3}$(alien_ssh_client)%f%F{$color14}`alien_venv`%f%F{$color8}%B❱%b%f '
  elif [[ $(alien_is_hg) == 1 ]]; then
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(alien_date_time_info)$(alien_battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %1~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`alien_hg_branch`%f%k%K{$color10}%F{$color7}%f%k%K{$color10}%F{$color11} %f%k%K{$color12}%F{$color10}%f%k%K{$color12}%F{$color13} %f%k%F{$color12}%f
%F{$color3}$(alien_ssh_client)%f%F{$color14}`alien_venv`%f%F{$color8}%B❱%b%f '
  elif [[ $(alien_is_svn) == 1 ]]; then
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(alien_date_time_info)$(alien_battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %1~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`alien_svn_branch`%f%k%K{$color10}%F{$color7}%f%k%K{$color10}%F{$color11} %f%k%K{$color12}%F{$color10}%f%k%K{$color12}%F{$color13} %f%k%F{$color12}%f
%F{$color3}$(alien_ssh_client)%f%F{$color14}`alien_venv`%f%F{$color8}%B❱%b%f '
  else
    PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(alien_date_time_info)$(alien_battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %1~ %f%k%F{$color5}%f
%F{$color3}$(alien_ssh_client)%f%F{$color14}`alien_venv`%f%F{$color8}%B❱%b%f '
  fi
  zle && zle reset-prompt
  async_stop_worker lprompt -n
}


alien_async_prompt(){
  async_init
  async_start_worker lprompt -n
  async_register_callback lprompt alien_lprompt_complete
  async_job lprompt alien_dummy
}
