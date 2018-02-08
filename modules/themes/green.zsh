#!/usr/bin/env zsh

alien_theme(){
  [[ -z $color0 ]]  && color0=022    # time bg
  [[ -z $color1 ]]  && color1=226    # init bg
  [[ -z $color1r ]] && color1r=196   # init bg error
  [[ -z $color2 ]]  && color2=254    # time fg
  [[ -z $color3 ]]  && color3=034    # user bg
  [[ -z $color4 ]]  && color4=232    # user fg
  [[ -z $color5 ]]  && color5=082    # dir bg
  [[ -z $color6 ]]  && color6=232    # dir fg
  [[ -z $color7 ]]  && color7=238    # vcs bg
  [[ -z $color8 ]]  && color8=228    # prompt fg
  [[ -z $color9 ]]  && color9=154    # vcs fg
}