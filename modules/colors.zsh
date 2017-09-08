#!/usr/bin/env zsh


if [[ "${ALIEN_THEME}" == "red" ]]; then
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
elif [[ "${ALIEN_THEME}" == "green" ]]; then
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
elif [[ "${ALIEN_THEME}" == "blue" ]]; then
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
color10=244     # lr bg
color11=255     # lr fg
color12=253     # dirty copy bg
color13=016     # dirty copy fg
color14=245     # venv color
