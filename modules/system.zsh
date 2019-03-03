#!/usr/bin/env zsh

alien_user_info(){
  if [[ "${DEFAULT_USER}" == "${USER}" ]]; then
    __user=''
  else
    [[ -n "$SUDO_USER" && "$SUDO_USER" != "${_user}" ]] && __user="$USER($SUDO_USER)" || __user="$USER"
  fi
  if [[ ${ALIEN_SECTION_USER_HOST} == 1 ]]; then
    __user+="@%M"
  fi
  echo -n "${__user}"
}

alien_storage_info(){
  __df=$(df -h . | tail -1)
  __fs=$(echo ${__df} | awk '{print $1}' | sed "s|\.|•|g")
  __size=$(echo ${__df} | awk '{print $2}' | sed "s|\.|•|g")
  __used=$(echo ${__df} | awk '{print $3}' | sed "s|\.|•|g")
  __usedp=$(echo ${__df} | awk '{print $5}' | sed "s|\.|•|g")
  __free=$(echo ${__df} | awk '{print $4}' | sed "s|\.|•|g")
  echo -n "💾 ${__fs} - F:${__free} U:${__used} T:${__size}"
  unset __df __fs __size __used __usedp __free
}

alien_time_info(){
  [[ -z ${ALIEN_SECTION_TIME_FORMAT} ]] && echo -n $(date +%r) || echo -n $(date +${ALIEN_SECTION_TIME_FORMAT})
}

alien_ssh_client(){
  if [[ -n "${SSH_CLIENT}" ]]; then
    echo -n ${SSH_CLIENT} | awk {'print $1" "'}
  fi
}

alien_battery_stat(){
  __os=$(uname)
  if [[ ${__os} = "Linux" ]]; then
    if which upower > /dev/null 2>&1 ; then
      __bat_power=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')
      __bat_power_ind=""
      if [[ ${__bat_power} = "charging" ]]; then __bat_power_ind="+"
      elif [[ ${__bat_power} = "discharging" ]]; then __bat_power_ind="-"
      elif [[ ${__bat_power} = "fully-charged" ]]; then __bat_power_ind="•"
      fi
      __bat_per=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | sed "s|%||g")
      if [[ -n ${__bat_per} ]]; then
        echo -n "${__bat_power_ind}${__bat_per}"
      fi
    fi
  fi
  if [[ ${__os} = "Darwin" ]]; then
    __bat_power=$(pmset -g batt | tail -1 | awk '{print $4}' | tr -d "%;")
    __bat_power_ind=""
    if [[ ${__bat_power} = "charging" ]]; then __bat_power_ind="+"
    elif [[ ${__bat_power} = "discharging" ]]; then __bat_power_ind="-"
    elif [[ ${__bat_power} = "finishing" ]]; then __bat_power_ind="+"
    elif [[ ${__bat_power} = "charged" ]]; then __bat_power_ind="•"
    fi
       __bat_per=$(pmset -g batt | tail -1 | awk '{print $3}' | tr -d "%;")
    if [[ -n ${__bat_per} ]]; then
      echo -n "${__bat_power_ind}${__bat_per}"
    fi
  fi

  unset __os __bat_power __bat_power_ind __bat_per
}
