#!/usr/bin/env zsh


if [[ "${ALIEN_THEME}" == "red" ]]; then
  [[ -z color0 ]] && color0=088    # time bg
  [[ -z color1 ]] && color1=226    # init bg
  [[ -z color1r ]] && color1r=196   # init bg error
  [[ -z color2 ]] && color2=254    # time fg
  [[ -z color3 ]] && color3=202    # user bg
  [[ -z color4 ]] && color4=232    # user fg
  [[ -z color5 ]] && color5=214    # dir bg
  [[ -z color6 ]] && color6=232    # dir fg
  [[ -z color7 ]] && color7=238    # vcs bg
  [[ -z color8 ]] && color8=228    # prompt fg
  [[ -z color9 ]] && color9=226    # vcs fg
elif [[ "${ALIEN_THEME}" == "green" ]]; then
  [[ -z color0 ]] && color0=022    # time bg
  [[ -z color1 ]] && color1=226    # init bg
  [[ -z color1r ]] && color1r=196   # init bg error
  [[ -z color2 ]] && color2=254    # time fg
  [[ -z color3 ]] && color3=034    # user bg
  [[ -z color4 ]] && color4=232    # user fg
  [[ -z color5 ]] && color5=082    # dir bg
  [[ -z color6 ]] && color6=232    # dir fg
  [[ -z color7 ]] && color7=238    # vcs bg
  [[ -z color8 ]] && color8=228    # prompt fg
  [[ -z color9 ]] && color9=154    # vcs fg
elif [[ "${ALIEN_THEME}" == "blue" ]]; then
  [[ -z color0 ]] && color0=018    # time bg
  [[ -z color1 ]] && color1=226    # init bg
  [[ -z color1r ]] && color1r=196   # init bg error
  [[ -z color2 ]] && color2=254    # time fg
  [[ -z color3 ]] && color3=026    # user bg
  [[ -z color4 ]] && color4=254    # user fg
  [[ -z color5 ]] && color5=045    # dir bg
  [[ -z color6 ]] && color6=019    # dir fg
  [[ -z color7 ]] && color7=238    # vcs bg
  [[ -z color8 ]] && color8=228    # prompt fg
  [[ -z color9 ]] && color9=051    # vcs fg
else
  [[ -z color0 ]] && color0=018    # time bg
  [[ -z color1 ]] && color1=226    # init bg
  [[ -z color1r ]] && color1r=196   # init bg error
  [[ -z color2 ]] && color2=254    # time fg
  [[ -z color3 ]] && color3=026    # user bg
  [[ -z color4 ]] && color4=254    # user fg
  [[ -z color5 ]] && color5=045    # dir bg
  [[ -z color6 ]] && color6=019    # dir fg
  [[ -z color7 ]] && color7=238    # vcs bg
  [[ -z color8 ]] && color8=228    # prompt fg
  [[ -z color9 ]] && color9=051    # vcs fg
fi
[[ -z color10 ]] && color10=244     # lr bg
[[ -z color11 ]] && color11=255     # lr fg
[[ -z color12 ]] && color12=253     # dirty copy bg
[[ -z color13 ]] && color13=016     # dirty copy fg
[[ -z color14 ]] && color14=245     # venv color
