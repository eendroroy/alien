# alien
[![Join the chat at https://gitter.im/eendroroy/alien](https://badges.gitter.im/eendroroy/alien.svg)](https://gitter.im/eendroroy/alien?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Requirements

- zsh (obviously)
- powerline patched fonts [**see here**](https://github.com/powerline/fonts)

### Installation

##### antigen

add in your .zshrc

    antigen theme eendroroy/alien alien

##### oh-my-zsh

- [**see here**](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-and-adding-themes)

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

