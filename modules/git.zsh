#!/usr/bin/env zsh

alien_is_git(){
  if [[ $(git branch 2>/dev/null) != "" ]]; then echo -n 1 ; else echo -n 0 ; fi
}

alien_git_branch_name() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref="detached" || return false;
  echo -n "${ref#refs/heads/}";
  return true;
}

alien_git_branch() {
  echo -n " G:  $(alien_git_branch_name) ";
  return true;
}

alien_git_lr(){
  if [[ $(alien_is_git) == 1 ]]; then
    if [[ $(alien_git_branch_name) != "detached" ]]; then
      _pull=$(git rev-list --left-right --count `alien_git_branch_name`...origin/`alien_git_branch_name` 2>/dev/null | awk '{print $2}' | tr -d ' \n');
      _push=$(git rev-list --left-right --count `alien_git_branch_name`...origin/`alien_git_branch_name` 2>/dev/null | awk '{print $1}' | tr -d ' \n');
      [[ "$_pull" != "0" ]] && [[ "$_pull" != "" ]] && echo -n "⇣ ";
      [[ "$_push" != "0" ]] && [[ "$_push" != "" ]] && echo -n "⇡ ";
    fi
  else
    echo -n "";
  fi
}

alien_git_dirty(){
  if [[ $(alien_is_git) == 1 ]]; then
    _mod=$(git status --porcelain 2>/dev/null | grep 'M ' | wc -l | tr -d ' ');
    _add=$(git status --porcelain 2>/dev/null | grep 'A ' | wc -l | tr -d ' ');
    _del=$(git status --porcelain 2>/dev/null | grep 'D ' | wc -l | tr -d ' ');
    _new=$(git status --porcelain 2>/dev/null | grep '?? ' | wc -l | tr -d ' ');
    [[ "$_mod" != "0" ]] && echo -n "⭑ ";
    [[ "$_add" != "0" ]] && echo -n "+ ";
    [[ "$_del" != "0" ]] && echo -n "- ";
    [[ "$_new" != "0" ]] && echo -n "? ";
  else
    echo -n "";
  fi
}