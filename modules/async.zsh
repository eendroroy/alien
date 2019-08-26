#!/usr/bin/env zsh

# shellcheck disable=SC2034

function alien_left_prompt_update_completed(){
  PROMPT=$(echo "${3}" | tr -s ' ')
  zle && zle reset-prompt
}

function alien_left_prompt_update() {
  cd "${1}" || return
  VIRTUAL_ENV=$2
  SSH_CLIENT=$3
  echo -n "$(alien_prompt_render_left 'async')"
}

alien_async_left_prompt(){
  async_init
  async_start_worker left_prompt -n
  async_register_callback left_prompt alien_left_prompt_update_completed
  async_job left_prompt alien_left_prompt_update "$(pwd)" "${VIRTUAL_ENV}" "${SSH_CLIENT}"
}

function alien_right_prompt_update_completed(){
  RPROMPT=$(echo "${3}" | tr -s ' ')
  zle && zle reset-prompt
}

function alien_right_prompt_update() {
  cd "${1}" || return
  VIRTUAL_ENV=$2
  SSH_CLIENT=$3
  echo -n "$(alien_prompt_render_right 'async')"
}

alien_async_right_prompt(){
  async_init
  async_start_worker right_prompt -n
  async_register_callback right_prompt alien_right_prompt_update_completed
  async_job right_prompt alien_right_prompt_update "$(pwd)" "${VIRTUAL_ENV}" "${SSH_CLIENT}"
}
