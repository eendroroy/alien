#!/usr/bin/env zsh

function alien_dummy(){}

function alien_lprompt_complete() {
  alien_prompt_start
  if [[ $(alien_is_git) == 1 ]]; then
    alien_prompt_append_section " $(alien_git_branch) " $color9 $color7
    __git_stash=$(alien_git_stash)
    __git_lr=$(alien_git_lr)
    __git_dirty=$(alien_git_dirty)
    if [[ -n "$__git_stash" ]] || [[ -n "$__git_lr" ]]; then
      alien_prompt_append_section "${__git_stash}${__git_lr}" $color9 $color7 $ALIEN_SECTION_SEP_SYM
    fi
    if [[ -n "$__git_dirty" ]]; then
      alien_prompt_append_section "${__git_dirty}" $color9 $color7 $ALIEN_SECTION_SEP_SYM
    fi
  elif [[ $(alien_is_hg) == 1 ]]; then
    alien_prompt_append_section "$(alien_hg_branch)" $color9 $color7 $ALIEN_SECTION_SEP_SYM
  elif [[ $(alien_is_svn) == 1 ]]; then
    alien_prompt_append_section "$(alien_svn_branch)" $color9 $color7 $ALIEN_SECTION_SEP_SYM
  fi
  alien_prompt_end
  PROMPT=$(alien_prompt_render)
  zle && zle reset-prompt
  async_stop_worker lprompt -n
}


alien_async_prompt(){
  async_init
  async_start_worker lprompt -n
  async_register_callback lprompt alien_lprompt_complete
  async_job lprompt alien_dummy
}
