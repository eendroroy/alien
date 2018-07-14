#!/usr/bin/env zsh


alien_storage_info(){
  fs=`df -h . | tail -1 | awk '{print $1}' | sed "s|\.|•|g" `;
  size=`df -h . | tail -1 | awk '{print $2}' | sed "s|\.|•|g" `;
  used=`df -h . | tail -1 | awk '{print $3}' | sed "s|\.|•|g" `;
  usedp=`df -h . | tail -1 | awk '{print $5}' | sed "s|\.|•|g" `;
  free=`df -h . | tail -1 | awk '{print $4}' | sed "s|\.|•|g" `;
  echo -n "💾 $fs - F:$free U:$used T:$size";
}

alien_date_time_info(){
  [[ -z $ALIEN_DATE_TIME_FORMAT ]] && echo -n "`date +%r`" || echo -n "`date +${ALIEN_DATE_TIME_FORMAT}`";
}

alien_ssh_client(){
  if [ -n "${SSH_CLIENT}" ]; then
    echo -n $SSH_CLIENT | awk {'print $1 " "'};
  fi
}

alien_battery_stat(){
  __os=`uname`;
  if [[ $__os = "Linux" ]]; then
    if which upower > /dev/null 2>&1 ; then
      __bat_power=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}'`;
      __bat_power_ind="";
      if [[ $__bat_power = "charging" ]]; then __bat_power_ind="+";
      elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="-";
      elif [[ $__bat_power = "fully-charged" ]]; then __bat_power_ind="•";
      fi
      __bat_per=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | sed "s|%||g"`;
      if [[ -n $__bat_per ]]; then
        echo -n " | ${__bat_power_ind}${__bat_per}";
      fi
    fi
  fi
  if [[ $__os = "Darwin" ]]; then
    __bat_power=`pmset -g batt | tail -1 | awk '{print $4}' | tr -d "%;"`;
    __bat_power_ind="";
    if [[ $__bat_power = "charging" ]]; then __bat_power_ind="+";
    elif [[ $__bat_power = "discharging" ]]; then __bat_power_ind="-";
    elif [[ $__bat_power = "finishing" ]]; then __bat_power_ind="+";
    elif [[ $__bat_power = "charged" ]]; then __bat_power_ind="•";
    fi
       __bat_per=`pmset -g batt | tail -1 | awk '{print $3}' | tr -d "%;"`
    if [[ -n $__bat_per ]]; then
      echo -n " | ${__bat_power_ind}${__bat_per}";
    fi
  fi

  unset __bat_power __bat_power_ind __bat_per
}