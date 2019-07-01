#!/usr/bin/env zsh

alien_prompt_colorize() {
  local __content="$1"
  local __fg="$2"
  local __bg="$3"
  [[ -n "$__fg" ]] && echo -en "%F{$__fg}"
  [[ -n "$__bg" ]] && echo -en "%K{$__bg}"
  echo -en "${__content}"
  [[ -n "$__bg" ]] && echo -en "%k"
  [[ -n "$__fg" ]] && echo -en "%f"
}

alien_prompt_render_left() {
  [[ ${#ALIEN_SECTIONS_LEFT} -ne 0 ]] || return
  local __render_mode=$1
  local __separator=$ALIEN_SECTIONS_LEFT_SEP_SYM
  local __last_bg=
  local __last_sep=
  for section in $ALIEN_SECTIONS_LEFT; do
    # section can define a render-mode in which it will be rendered
    # render-mode is defined by appending :<mode>
    IFS=":" read __section_name __section_render_mode <<< $section
    local __section_function="alien_prompt_section_${__section_name}"
    # check if a function is defined for the section
    if whence -w $__section_function >/dev/null && \
      (
        [[ -z "$__section_render_mode" ]] || \
        [[ "$__section_render_mode" == "$__render_mode" ]] \
      )
    then
      # declare variable in which the section-function writes its information
      typeset -A __section=()
      $__section_function
      # skip section if section-function returned false
      [[ $? -ne 0 ]] && continue
      local __content=${__section[content]}
      local __fg=${__section[foreground]}
      local __bg=${__section[background]}
      local __sep=${__section[separator]+${__section[separator]}}
      [[ -n "$__last_sep" ]] && alien_prompt_colorize "$__last_sep" "$__last_bg" "$__bg"
      __last_bg="$__bg"
      [[ -n $__sep ]] && __last_sep="$__separator" || __last_sep=""
      alien_prompt_colorize "$__content" "$__fg" "$__bg"
    fi
  done
  [[ -n "$__last_sep" ]] && alien_prompt_colorize "$__last_sep" "$__last_bg"
}

alien_prompt_render_right() {
  [[ ${#ALIEN_SECTIONS_RIGHT} -ne 0 ]] || return
  local __render_mode=$1
  local __separator=$ALIEN_SECTIONS_RIGHT_SEP_SYM
  local __last_bg=
  local __newline_in_left=
  local __rprompt_prefix=
  local __rprompt_suffix=
  # using ZLE_RPROMPT_INDENT=0 causes a bug, therefore we emulate it in this way
  echo -ne "%1{ %}"
  # if there is a newline in PROMPT we have to move the cursor to get RPROMPT on the first line
  if [[ ${ALIEN_SECTIONS_LEFT[(r)newline]} == newline ]]; then
    __rprompt_prefix='%{'$'\e[1A''%}' # one line up
    __rprompt_suffix='%{'$'\e[1B''%}' # one line down
  fi
  echo -ne $__rprompt_prefix
  for section in $ALIEN_SECTIONS_RIGHT; do
    # section can define a render-mode in which it will be rendered
    # render-mode is defined by appending :<mode>
    IFS=":" read __section_name __section_render_mode <<< $section
    local __section_function="alien_prompt_section_${__section_name}"
    # check if a function is defined for the section
    if whence -w $__section_function >/dev/null && \
      (
        [[ -z "$__section_render_mode" ]] || \
        [[ "$__section_render_mode" == "$__render_mode" ]] \
      )
    then
      # declare variable in which the section-function writes its information
      typeset -A __section=()
      $__section_function
      # skip section if section-function returned false
      [[ $? -ne 0 ]] && continue
      local __content=${__section[content]}
      local __fg=${__section[foreground]}
      local __bg=${__section[background]}
      local __sep=${__section[separator]+${__section[separator]}}
      [[ -n $__sep ]] && alien_prompt_colorize "$__separator" "$__bg" $__last_bg
      __last_bg="$__bg"
      alien_prompt_colorize "$__content" "$__fg" "$__bg"
    fi
  done
  echo -ne $__rprompt_suffix
}
