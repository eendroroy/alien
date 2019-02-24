#!/usr/bin/env zsh

ALIEN_PROMPT_SECTIONS=()

alien_colorized() {
  local __content="$1"
  local __fg="$2"
  local __bg="$3"
  [[ -n "$__fg" ]] && echo -en "%F{$__fg}"
  [[ -n "$__bg" ]] && echo -en "%K{$__bg}"
  echo -en "${__content}"
  [[ -n "$__bg" ]] && echo -en "%k"
  [[ -n "$__fg" ]] && echo -en "%f"
}

alien_prompt_append_section() {
  local __content=$1
  local __fg=$2
  local __bg=$3
  local __sep=$4
  ALIEN_PROMPT_SECTIONS+=("$__content","$__fg","$__bg","$__sep")
}

alien_prompt_prepend_section() {
  local __content=$1
  local __fg=$2
  local __bg=$3
  local __sep=$4
  ALIEN_PROMPT_SECTIONS=("$__content","$__fg","$__bg","$__sep" ${ALIEN_PROMPT_SECTIONS[@]})
}

alien_prompt_render() {
  local __last_bg=
  local __last_sep=
  for section in $ALIEN_PROMPT_SECTIONS; do
    # set read-delimiter to \0 and add it to $section in order to allow \n in content
    IFS=',' read -d"\0" __content __fg __bg __sep <<< "${section}\0"
    [[ -n "$__last_sep" ]] && alien_colorized "$__last_sep" "$__last_bg" "$__bg"
    __last_bg="$__bg"
    __last_sep="$__sep"
    alien_colorized "$__content" "$__fg" "$__bg"
  done
  alien_colorized "$__last_sep" "$__last_bg"
}

alien_prompt_start() {
  ALIEN_PROMPT_SECTIONS=()
  # date/time section
  if [[ $ALIEN_SHOW_DATE_TIME != 0 ]]; then
    alien_prompt_append_section " $(alien_date_time_info) " $color2 $color0 $ALIEN_SECTION_SEP_SYM
  fi
  # battery section
  if [[ $ALIEN_SHOW_BATTERY != 0 ]]; then
    alien_prompt_append_section " $(alien_battery_stat) " $color2 $color0 $ALIEN_SECTION_SEP_SYM
  fi
  # user/host section
  if [[ $ALIEN_SHOW_USER_HOST != 0 ]]; then
    alien_prompt_append_section " $(alien_user_host_info) " $color4 $color3 $ALIEN_SECTION_SEP_SYM
  fi
  # path section
  if [[ $ALIEN_LONG_PATH != 0 ]]; then
    alien_prompt_append_section " %~ " $color6 $color5 $ALIEN_SECTION_SEP_SYM
  else
    alien_prompt_append_section " %1~ " $color6 $color5 $ALIEN_SECTION_SEP_SYM
  fi
  # determine background-color of first section
  IFS=',' read -d"\0" __content __fg __bg __sep <<< "${ALIEN_PROMPT_SECTIONS[1]}\0"
  # prepend exit-code section
  local __exit_code_info="%(?"
  __exit_code_info+=".$(alien_colorized $ALIEN_SECTION_SEP_SYM $color1 $__bg)"
  if [[ $ALIEN_SHOW_EXIT_CODE != 0 ]]; then
    __exit_code_info+=".$(alien_colorized "%?" $color2 $color1r)"
    __exit_code_info+="$(alien_colorized "$ALIEN_SECTION_SEP_SYM" $color1r $__bg)"
  else
    __exit_code_info+=".$(alien_colorized "$ALIEN_SECTION_SEP_SYM" $color1r $__bg)"
  fi
  __exit_code_info+=")"
  alien_prompt_prepend_section $__exit_code_info
}

alien_prompt_end() {
  # newline
  alien_prompt_append_section $'\n'
  # ssh-client section
  alien_prompt_append_section "$(alien_ssh_client)" $color3
  # venv section
  alien_prompt_append_section "$(alien_venv)" $color14
  # prompt
  alien_prompt_append_section "%B${ALIEN_PROMPT_SYM}%b " $color8
}
