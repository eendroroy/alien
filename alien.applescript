tell application "iTerm"
	create window with default profile
	tell current session of current window
		delay 5
		write text "rm ~/alien-2.0.0"
		delay 2
		write text "asciinema rec ~/alien-2.0.0"
		delay 5
		write text "false"
		delay 2
		write text "true"
		delay 2
		write text "z alien-demo"
		delay 2
		write text "export ALIEN_SECTIONS_LEFT=(exit battery user vcs_branch:async vcs_status:async vcs_dirty:async newline ssh venv prompt)"
		delay 2
		write text "export ALIEN_SECTIONS_LEFT=(exit time battery user newline ssh venv prompt)"
		delay 2
		write text "export ALIEN_SECTIONS_RIGHT=(vcs_branch:async vcs_status:async vcs_dirty:async)"
		delay 2
		write text "export ALIEN_SECTIONS_RIGHT=(vcs_dirty:async vcs_status:async vcs_branch:async)"
		delay 2
		write text "export ALIEN_KEEP_PROMPT=1"
		delay 2
		write text "cd"
		delay 2
		write text "cd -"
		delay 2
		write text "export ALIEN_SECTIONS_LEFT=(exit time battery user path newline ssh venv prompt)"
		delay 2
		write text "export ALIEN_SECTION_PATH_COMPONENTS=4"
		delay 2
		write text "export ALIEN_SECTION_PATH_COMPONENTS=3"
		delay 2
		write text "export ALIEN_SECTION_PATH_COMPONENTS=1"
		delay 2
		write text "source venv/bin/activate"
		delay 2
		write text "export ALIEN_SECTIONS_LEFT=(battery user vcs_branch:async vcs_status:async vcs_dirty:async newline ssh venv prompt)"
		write text "export ALIEN_SECTIONS_RIGHT=(time exit)"
		delay 2
		write text "false"
		delay 2
		write text "true"
		delay 2
		write text "export ALIEN_THEME=blue"
		delay 2
		write text "export ALIEN_THEME=green"
		delay 2
		write text "export ALIEN_THEME=red"
		delay 2
		write text "export ALIEN_THEME=soft"
		delay 2
		write text "unset ALIEN_THEME"
		delay 2
		write text "deactivate"
		delay 2
		write text "exit"
		delay 5
		write text "exit"
	end tell
end tell