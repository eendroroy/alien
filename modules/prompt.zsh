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
  # time section
  if [[ $ALIEN_SECTION_TIME_ENABLE != 0 ]]; then
    alien_prompt_append_section " $(alien_time_info) " \
      $ALIEN_SECTION_TIME_FG $ALIEN_SECTION_TIME_BG $ALIEN_SECTION_SEP_SYM
  fi
  # battery section
  if [[ $ALIEN_SECTION_BATTERY_ENABLE != 0 ]]; then
    alien_prompt_append_section " $(alien_battery_stat) " \
      $ALIEN_SECTION_BATTERY_FG $ALIEN_SECTION_BATTERY_BG $ALIEN_SECTION_SEP_SYM
  fi
  # user section
  if [[ $ALIEN_SECTION_USER_ENABLE != 0 ]]; then
    alien_prompt_append_section " $(alien_user_info) " \
      $ALIEN_SECTION_USER_FG $ALIEN_SECTION_USER_BG $ALIEN_SECTION_SEP_SYM
  fi
  # path section
  if [[ $ALIEN_SECTION_PATH_ENABLE != 0 ]]; then
    if [[ -z $ALIEN_SECTION_PATH_COMPONENTS ]]; then
      __path_info="%~"
    else
      __path_info="%${ALIEN_SECTION_PATH_COMPONENTS}~"
    fi
    alien_prompt_append_section " ${__path_info} " \
      $ALIEN_SECTION_PATH_FG $ALIEN_SECTION_PATH_BG $ALIEN_SECTION_SEP_SYM
  fi
  # exit section
  if [[ $ALIEN_SECTION_EXIT_ENABLE != 0 ]]; then
    # determine background-color of first section
    IFS=',' read -d"\0" __content __fg __bg __sep <<< "${ALIEN_PROMPT_SECTIONS[1]}\0"
    # prepend exit-code section
    local __exit_code_info="%(?"
    __exit_code_info+=".$(alien_colorized $ALIEN_SECTION_SEP_SYM $ALIEN_SECTION_EXIT_BG $__bg)"
    if [[ $ALIEN_SECTION_EXIT_CODE != 0 ]]; then
      __exit_code_info+=".$(alien_colorized " %? " $ALIEN_SECTION_EXIT_FG $ALIEN_SECTION_EXIT_BG_ERROR)"
      __exit_code_info+="$(alien_colorized $ALIEN_SECTION_SEP_SYM $ALIEN_SECTION_EXIT_BG_ERROR $__bg)"
    else
      __exit_code_info+=".$(alien_colorized $ALIEN_SECTION_SEP_SYM $ALIEN_SECTION_EXIT_BG_ERROR $__bg)"
    fi
    __exit_code_info+=")"
    alien_prompt_prepend_section $__exit_code_info
  fi
}

alien_prompt_end() {
  # newline
  alien_prompt_append_section $'\n'
  # ssh-client section
  alien_prompt_append_section "$(alien_ssh_client)" $ALIEN_SECTION_SSH_FG
  # venv section
  alien_prompt_append_section "$(alien_venv)" $ALIEN_SECTION_VENV_FG
  # prompt
  alien_prompt_append_section "%B${ALIEN_PROMPT_SYM}%b " $ALIEN_PROMPT_FG
}
