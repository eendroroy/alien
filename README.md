# alien

alien theme is faster than a lot other themes. Why? It updates part of the prompt asyncronously. The time consuming processings like git status checking, git dirty copy checking etc. asynchronously. It starts a background job for these process, and in the mean time draws initial prompt and lets you use the terminal as you would normally.

alien theme is independent of any library like Oh-My-Zsh or Prezto. Whatever it needs already included inside. The only
exception is font. You need to install the powerline patched fonts to properly dysplay the prompt.

### Requirements

- zsh (obviously)
- powerline patched fonts [**see here**](https://github.com/powerline/fonts)

### Installation

Add the following line to your .zshrc depending on your zsh plugin manager

##### [antigen](https://github.com/zsh-users/antigen):

    antigen theme eendroroy/alien alien

##### [zgen](https://github.com/tarjoilija/zgen):

    zgen load eendroroy/alien

##### [zplug](https://github.com/zplug/zplug):

    zplug "eendroroy/alien"

##### [oh-my-zsh: Overriding and Adding Themes](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-and-adding-themes)

#### screencast

[![asciicast](https://asciinema.org/a/121489.png)](https://asciinema.org/a/121489)

###### color scheme

you can chose from 3 different color schemes (blue is the default)

in ~/.zshrc just add any from the following three lines before your 'antigen theme ...' line

    export ALIEN_THEME="blue"

    export ALIEN_THEME="green"

    export ALIEN_THEME="red"

Credit goes to [@chrissicool](https://github.com/chrissicool) for ['zsh-256color'](https://github.com/chrissicool/zsh-256color)

Credit goes to [@mafredri](https://github.com/mafredri) for ['zsh-async'](https://github.com/mafredri/zsh-async)

