#!/usr/bin/env zsh

__color_man_page(){
  export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
  export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
  export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
  export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
  export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
  export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
  export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan
}

_is_svn(){
  if [[ $(svn info 2>/dev/null) != "" ]]; then echo 1 ; else echo 0 ; fi
}

_svn_branch() {
  ref=$(svn info 2>/dev/null | grep Revision | awk '{print $2}') || return false;
  echo " SVN: @${ref} ";
  return true;
}

_is_git(){
  if [[ $(git branch 2>/dev/null) != "" ]]; then echo 1 ; else echo 0 ; fi
}

_git_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return false;
  echo " GIT:  ${ref#refs/heads/} ";
  return true;
}

_is_hg(){
  if [[ $(hg branch 2>/dev/null) != "" ]]; then echo 1 ; else echo 0 ; fi
}

_hg_branch() {
  ref=$(hg branch 2> /dev/null) || return true;
  echo " HG:  ${ref} ";
  return true;
}

_vcs_info(){
  if [[ $(_is_git) == 1 ]]; then
    _git_branch;
  elif [[ $(_is_hg) == 1 ]]; then
    _hg_branch;
  elif [[ $(_is_svn) == 1 ]]; then
    _svn_branch;
  else
    echo " ";
  fi
}

__storage_info(){
  fs=`df -h . | tail -1 | awk '{print $1}' | sed "s|\.|•|g" `;
  size=`df -h . | tail -1 | awk '{print $2}' | sed "s|\.|•|g" `;
  used=`df -h . | tail -1 | awk '{print $3}' | sed "s|\.|•|g" `;
  usedp=`df -h . | tail -1 | awk '{print $5}' | sed "s|\.|•|g" `;
  free=`df -h . | tail -1 | awk '{print $4}' | sed "s|\.|•|g" `;
  echo "💾 $fs - F:$free U:$used T:$size";
}
__date_time_info(){
  echo "`date +%r`";
}

__ssh_client(){
  if [ -n "$SSH_CLIENT" ]; then
    echo $SSH_CLIENT | awk {'print $1 " "'};
  fi
}

__battery_stat(){
  __bat_power=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}'`;
  __bat_power_ind="";
  if [[ $__bat_power = "charging" ]]; then __bat_power_ind="+";
  elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="-";
  elif [[ $__bat_power = "fully-charged" ]]; then __bat_power_ind="◉ ";
  fi
  __bat_per=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | sed "s|%||g"`;
  if [[ -n $__bat_per ]]; then
    echo " (B:${__bat_power_ind}${__bat_per})";
  fi
}

alien0(){
  if [[ $ALIEN_THEME == "red" ]]; then
    color0=088    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=202    # user bg
    color4=232    # user fg
    color5=214    # dir bg
    color6=232    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=226    # vcs fg
  elif [[ $ALIEN_THEME == "green" ]]; then
    color0=022    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=034    # user bg
    color4=232    # user fg
    color5=082    # dir bg
    color6=232    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=154    # vcs fg
  elif [[ $ALIEN_THEME == "blue" ]]; then
    color0=018    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=026    # user bg
    color4=254    # user fg
    color5=045    # dir bg
    color6=019    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=051    # vcs fg
  else
    color0=018    # time bg
    color1=226    # init bg
    color1r=196   # init bg error
    color2=254    # time fg
    color3=026    # user bg
    color4=254    # user fg
    color5=045    # dir bg
    color6=019    # dir fg
    color7=238    # vcs bg
    color8=228    # prompt fg
    color9=051    # vcs fg
  fi

  RPROMPT=''
  _user=`whoami`
  setopt promptsubst
  PROMPT='
%(?.%K{$color0}%F{$color1}%f%k.%K{$color0}%F{$color1r}%f%k)%K{$color0}%F{$color2} $(__date_time_info)$(__battery_stat) %f%k%K{$color3}%F{$color0}%f%k%K{$color3}%F{$color4} $_user %f%k%K{$color5}%F{$color3}%f%k%K{$color5}%F{$color6} %5~ %f%k%F{$color5}%K{$color7}%k%f%K{$color7}%F{$color9}`_vcs_info`%f%k%F{$color7}%f
%F{$color3}$(__ssh_client)%f%F{$color8}%B❱%b%f '
}

alien_prompts(){
  alien0
}

autoload -U add-zsh-hook
alien_prompts

