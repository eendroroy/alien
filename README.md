# alien

[![GitHub tag](https://img.shields.io/github/tag/eendroroy/alien.svg)](https://github.com/eendroroy/alien/tags)

[![Contributors](https://img.shields.io/github/contributors/eendroroy/alien.svg)](https://github.com/eendroroy/alien/graphs/contributors)
[![GitHub last commit (branch)](https://img.shields.io/github/last-commit/eendroroy/alien/master.svg)](https://github.com/eendroroy/alien)
[![license](https://img.shields.io/github/license/eendroroy/alien.svg)](https://github.com/eendroroy/alien/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/eendroroy/alien.svg)](https://github.com/eendroroy/alien/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed/eendroroy/alien.svg)](https://github.com/eendroroy/alien/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/eendroroy/alien.svg)](https://github.com/eendroroy/alien/pulls)
[![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/eendroroy/alien.svg)](https://github.com/eendroroy/alien/pulls?q=is%3Apr+is%3Aclosed)

**alien** theme is faster than a lot other themes.

**Why?** It updates part of the prompt asyncronously - the time consuming processings like git status checking,
git dirty copy checking etc.

**How?** It starts a background job for these process, and in the mean time draws initial prompt and lets you use the
terminal as you would normally.

alien theme is **independent** of any library like Oh-My-Zsh or Prezto. Whatever it needs already included inside.
The only exception is font. You need to **install the powerline patched fonts** to properly display the prompt.

## Asciicast v2.0.0

[![asciicast](http://asciinema.org/a/237118.svg)](http://asciinema.org/a/237118)

## Requirements

- zsh (obviously)
- powerline patched fonts [**see here**](https://github.com/powerline/fonts)

## Installation

Add the following line to your `.zshrc` depending on your zsh plugin manager

#### [antigen](https://github.com/zsh-users/antigen):

    antigen theme eendroroy/alien alien

#### [zgen](https://github.com/tarjoilija/zgen):

    zgen load eendroroy/alien

#### [zplug](https://github.com/zplug/zplug):

    zplug "eendroroy/alien"

#### [oh-my-zsh: Overriding and Adding Themes](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-and-adding-themes)

#### Manually cloning

```bash
git clone https://github.com/eendroroy/alien.git
cd alien
git submodule update --init --recursive
```

Add the following line to your `~/.zshrc`

```bash
source ~/alien/alien.zsh
```

## Configuration

### sections

To define the order of sections to display:

```bash
export ALIEN_SECTIONS_LEFT=(
  exit
  battery
  user
  path
  newline
  ssh
  venv
  prompt
)

export ALIEN_SECTIONS_RIGHT=(
  time
)
```

To define if sections are to be loaded asyncronously add `:async` to the section-name:

```bash
export ALIEN_SECTIONS_LEFT=(
  exit
  battery
  user
  path
  vcs_branch:async
  vcs_status:async
  vcs_dirty:async
  newline
  ssh
  venv
  prompt
)
```

#### section seperator

To change the section-separator:

```bash
export ALIEN_SECTIONS_LEFT_SEP_SYM=
export ALIEN_SECTIONS_RIGHT_SEP_SYM=
```


#### `prompt`-section

To change the symbol of the input-prompt:

```bash
export ALIEN_PROMPT_SYM=
```

To change colors:

```bash
export ALIEN_PROMPT_FG=100
```

#### `exit`-section

To disable the numeric exit-code:

```bash
export ALIEN_SECTION_EXIT_CODE=0
```

To change colors:

```bash
export ALIEN_SECTION_EXIT_FG=100
export ALIEN_SECTION_EXIT_BG=150
export ALIEN_SECTION_EXIT_BG_ERROR=200
```

#### `time`-section

To change the format::

```bash
export ALIEN_SECTION_TIME_FORMAT=%H:%M:%S # default is %r
```

To change colors:

```bash
export ALIEN_SECTION_TIME_FG=100
export ALIEN_SECTION_TIME_BG=150
```

#### `battery`-section

To change colors:

```bash
export ALIEN_SECTION_BATTERY_FG=100
export ALIEN_SECTION_BATTERY_BG=150
```

#### `user`-section

To show the hostname:

```bash
export ALIEN_SECTION_USER_HOST=1
```

To change colors:

```bash
export ALIEN_SECTION_USER_FG=100
export ALIEN_SECTION_USER_BG=150
```

#### `path`-section

To change the number of path-components to display:

```bash
export ALIEN_SECTION_PATH_COMPONENTS=2
```

To change colors:

```bash
export ALIEN_SECTION_PATH_FG=100
export ALIEN_SECTION_PATH_BG=150
```

#### `vcs_branch`-section

To change colors:

```bash
export ALIEN_SECTION_VCS_BRANCH_FG=100
export ALIEN_SECTION_VCS_BRANCH_BG=150
```

#### `vcs_status`-section

To change colors:

```bash
export ALIEN_SECTION_VCS_STATUS_FG=100
export ALIEN_SECTION_VCS_STATUS_BG=150
```

#### `vcs_dirty`-section

To change colors:

```bash
export ALIEN_SECTION_VCS_DIRTY_FG=100
export ALIEN_SECTION_VCS_DIRTY_BG=150
```

### color scheme

**add all configurations before plugin definitions**

you can chose from 3 different color schemes (blue is the default)

in ~/.zshrc just add any from the following three lines before your `antigen theme ...` line

```bash
export ALIEN_THEME="blue"
```

![blue](https://raw.githubusercontent.com/eendroroy/alien/master/screenshots/blue.png)

```bash
export ALIEN_THEME="green"
```

![green](https://raw.githubusercontent.com/eendroroy/alien/master/screenshots/green.png)

```bash
export ALIEN_THEME="red"
```

![red](https://raw.githubusercontent.com/eendroroy/alien/master/screenshots/red.png)

```bash
export ALIEN_THEME="soft"
```

![soft](https://raw.githubusercontent.com/eendroroy/alien/master/screenshots/soft.png)

```bash
export ALIEN_THEME="gruvbox"
```

![gruvbox](https://raw.githubusercontent.com/eendroroy/alien/master/screenshots/gruvbox.png)


**Custom Color**

```bash
ALIEN_PROMPT_FG=87

ALIEN_SECTION_EXIT_FG=0
ALIEN_SECTION_EXIT_BG=87
ALIEN_SECTION_EXIT_BG_ERROR=202

ALIEN_SECTION_TIME_FG=0
ALIEN_SECTION_TIME_BG=193

ALIEN_SECTION_BATTERY_FG=0
ALIEN_SECTION_BATTERY_BG=193

ALIEN_SECTION_USER_FG=0
ALIEN_SECTION_USER_BG=87

ALIEN_SECTION_PATH_FG=0
ALIEN_SECTION_PATH_BG=45

ALIEN_SECTION_VCS_BRANCH_FG=87
ALIEN_SECTION_VCS_BRANCH_BG=238
ALIEN_SECTION_VCS_STATUS_FG=87
ALIEN_SECTION_VCS_STATUS_BG=238
ALIEN_SECTION_VCS_DIRTY_FG=87
ALIEN_SECTION_VCS_DIRTY_BG=238

ALIEN_SECTION_SSH_FG=238

ALIEN_SECTION_VENV_FG=238

PLIB_GIT_TRACKED_COLOR=193
PLIB_GIT_UNTRACKED_COLOR=87
```

Or creating a new theme file:

__/path/to/custom/theme.zsh__

```bash
#!/usr/bin/env zsh

alien_theme(){
  ALIEN_PROMPT_FG=87

  ALIEN_SECTION_EXIT_FG=0
  ALIEN_SECTION_EXIT_BG=87
  ALIEN_SECTION_EXIT_BG_ERROR=202

  ALIEN_SECTION_TIME_FG=0
  ALIEN_SECTION_TIME_BG=193

  ALIEN_SECTION_BATTERY_FG=0
  ALIEN_SECTION_BATTERY_BG=193

  ALIEN_SECTION_USER_FG=0
  ALIEN_SECTION_USER_BG=87

  ALIEN_SECTION_PATH_FG=0
  ALIEN_SECTION_PATH_BG=45

  ALIEN_SECTION_VCS_BRANCH_FG=87
  ALIEN_SECTION_VCS_BRANCH_BG=238
  ALIEN_SECTION_VCS_STATUS_FG=87
  ALIEN_SECTION_VCS_STATUS_BG=238
  ALIEN_SECTION_VCS_DIRTY_FG=87
  ALIEN_SECTION_VCS_DIRTY_BG=238

  ALIEN_SECTION_SSH_FG=238

  ALIEN_SECTION_VENV_FG=238

  PLIB_GIT_TRACKED_COLOR=193
  PLIB_GIT_UNTRACKED_COLOR=87
}
```

Then activate the theme using:

```bash
export ALIEN_CUSTOM_THEME_PATH=/path/to/custom/theme.zsh
```

### Keep previous PROMPT:

```bash
export ALIEN_KEEP_PROMPT=1
```

This will keep previous prompt while new prompt is being rendered.

### nerd font

Enable Nerd Font

```bash
export USE_NERD_FONT=1
```

_*Note: [Nerd fonts](https://github.com/ryanoasis/nerd-fonts)*_


### promptlib-zsh Configs:

#### customize symbols

```bash
export ALIEN_GIT_STASH_SYM=@
export ALIEN_GIT_SYM=G
export ALIEN_HG_SYM=H
export ALIEN_SVN_SYM=S
export ALIEN_BRANCH_SYM=
# Symbols from promptlib
export PLIB_GIT_ADD_SYM=+
export PLIB_GIT_DEL_SYM=-
export PLIB_GIT_MOD_SYM=⭑
export PLIB_GIT_NEW_SYM=?
export PLIB_GIT_PUSH_SYM=↑
export PLIB_GIT_PULL_SYM=↓
```

_Note: this overrides `USE_NERD_FONT` configuration._

#### customize colors

```bash
export PLIB_GIT_TRACKED_COLOR=green
export PLIB_GIT_UNTRACKED_COLOR=red
```

## Libraries Used

- ['256color'](https://github.com/chrissicool/zsh-256color) by **[@chrissicool](https://github.com/chrissicool)**
- ['zsh-async'](https://github.com/mafredri/zsh-async) by **[@mafredri](https://github.com/mafredri)**
- ['promptlib-zsh'](https://github.com/eendroroy/promptlib-zsh) by **[@eendroroy](https://github.com/eendroroy)**

## Author

* **indrajit** - *Owner* - [eendroroy](https://github.com/eendroroy)

## Contributing

Bug reports and pull requests are welcome on GitHub at [alien](https://github.com/eendroroy/alien) repository.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

  1. Fork it ( https://github.com/eendroroy/alien/fork )
  1. Create your feature branch (`git checkout -b my-new-feature`)
  1. Commit your changes (`git commit -am 'Add some feature'`)
  1. Push to the branch (`git push origin my-new-feature`)
  1. Create a new Pull Request


## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
