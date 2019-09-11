#!/usr/bin/env zsh

# shellcheck disable=SC2116

alien_python_version(){
  echo -ne "%F{$ALIEN_PYTHON_COLOR}${ALIEN_PY_SYM}$(plib_python_version)%f"
}

alien_python_short_version(){
  echo -ne "%F{$ALIEN_PYTHON_COLOR}${ALIEN_PY_SYM}$(plib_python_major_minor_version)%f"
}

alien_ruby_version(){
  echo -ne "%F{$ALIEN_RUBY_COLOR}${ALIEN_RB_SYM}$(plib_ruby_version)%f"
}

alien_ruby_short_version(){
  echo -ne "%F{$ALIEN_RUBY_COLOR}${ALIEN_RB_SYM}$(plib_ruby_major_minor_version)%f"
}

alien_java_version(){
  echo -ne "%F{$ALIEN_JAVA_COLOR}${ALIEN_JAVA_SYM}$(plib_java_version)%f"
}

alien_java_short_version(){
  echo -ne "%F{$ALIEN_JAVA_COLOR}${ALIEN_JAVA_SYM}$(plib_java_major_version)%f"
}

alien_go_version(){
  echo -ne "%F{$ALIEN_GO_COLOR}${ALIEN_GO_SYM}$(plib_go_version)%f"
}

alien_go_short_version(){
  echo -ne "%F{$ALIEN_GO_COLOR}${ALIEN_GO_SYM}$(plib_go_major_minor_version)%f"
}

alien_elixir_version(){
  echo -ne "%F{$ALIEN_ELIXIR_COLOR}${ALIEN_ELIXIR_SYM}$(plib_elixir_version)%f"
}

alien_elixir_short_version(){
  echo -ne "%F{$ALIEN_ELIXIR_COLOR}${ALIEN_ELIXIR_SYM}$(plib_elixir_major_minor_version)%f"
}

alien_crystal_version(){
  echo -ne "%F{$ALIEN_CRYSTAL_COLOR}${ALIEN_CRYSTAL_SYM}$(plib_crystal_version)%f"
}

alien_crystal_short_version(){
  echo -ne "%F{$ALIEN_CRYSTAL_COLOR}${ALIEN_CRYSTAL_SYM}$(plib_crystal_major_minor_version)%f"
}

alien_node_version(){
  echo -ne "%F{$ALIEN_NODE_COLOR}${ALIEN_NODE_SYM}$(plib_node_version)%f"
}

alien_node_short_version(){
  echo -ne "%F{$ALIEN_NODE_COLOR}${ALIEN_NODE_SYM}$(plib_node_major_minor_version)%f"
}

alien_php_version(){
  echo -ne "%F{$ALIEN_PHP_COLOR}${ALIEN_PHP_SYM}$(plib_php_version)%f"
}

alien_php_short_version(){
  echo -ne "%F{$ALIEN_PHP_COLOR}${ALIEN_PHP_SYM}$(plib_php_major_minor_version)%f"
}

alien_version_prompt(){
  if [[ -n ${ALIEN_VERSIONS_PROMPT} ]]; then
    LOOP_INDEX=0
    for _v in $(echo "${ALIEN_VERSIONS_PROMPT}"); do
      [[ ${LOOP_INDEX} != "0" ]] && version_prompt_val+="%F{$ALIEN_FADE_COLOR}${ALIEN_VERSION_PROMPT_SEP}%f"
      [[ ${LOOP_INDEX} == "0" ]] && LOOP_INDEX=$((LOOP_INDEX + 1))

      [[ ${_v} == "PYTHON" ]]    && version_prompt_val+="$(alien_python_version)"
      [[ ${_v} == "PYTHON_S" ]]  && version_prompt_val+="$(alien_python_short_version)"
      [[ ${_v} == "RUBY" ]]      && version_prompt_val+="$(alien_ruby_version)"
      [[ ${_v} == "RUBY_S" ]]    && version_prompt_val+="$(alien_ruby_short_version)"
      [[ ${_v} == "JAVA" ]]      && version_prompt_val+="$(alien_java_version)"
      [[ ${_v} == "JAVA_S" ]]    && version_prompt_val+="$(alien_java_short_version)"
      [[ ${_v} == "GO" ]]        && version_prompt_val+="$(alien_go_version)"
      [[ ${_v} == "GO_S" ]]      && version_prompt_val+="$(alien_go_short_version)"
      [[ ${_v} == "ELIXIR" ]]    && version_prompt_val+="$(alien_elixir_version)"
      [[ ${_v} == "ELIXIR_S" ]]  && version_prompt_val+="$(alien_elixir_short_version)"
      [[ ${_v} == "CRYSTAL" ]]   && version_prompt_val+="$(alien_crystal_version)"
      [[ ${_v} == "CRYSTAL_S" ]] && version_prompt_val+="$(alien_crystal_short_version)"
      [[ ${_v} == "NODE" ]]      && version_prompt_val+="$(alien_node_version)"
      [[ ${_v} == "NODE_S" ]]    && version_prompt_val+="$(alien_node_short_version)"
      [[ ${_v} == "PHP" ]]       && version_prompt_val+="$(alien_php_version)"
      [[ ${_v} == "PHP_S" ]]     && version_prompt_val+="$(alien_php_short_version)"
    done

    [[ "$LOOP_INDEX" != "0" ]] && version_prompt_val+=" "
  fi
  echo -n "${version_prompt_val}"
}