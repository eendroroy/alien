#!/usr/bin/env zsh

function alien_dummy(){}

function alien_lprompt_complete() {
  PROMPT=$(alien_prompt_render_left 'async')
  RPROMPT=$(alien_prompt_render_right 'async')
  zle && zle reset-prompt
  async_stop_worker lprompt -n
}

alien_async_prompt(){
  async_init
  async_start_worker lprompt -n
  async_register_callback lprompt alien_lprompt_complete
  async_job lprompt alien_dummy
}
