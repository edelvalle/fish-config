# Aliases
alias m "python manage.py"
alias you-mp3 "youtube-dl -x --audio-format mp3 --audio-quality 0"

# Greetings commander
set fish_greeting ""

# Colors
set normal (set_color normal)
set magenta (set_color magenta)
set bryellow (set_color bryellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

eval (python -m virtualfish compat_aliases)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch bryellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'


function fish_prompt --description 'Write out the prompt'
    set -l color_cwd
    set -l suffix

    if set -q VIRTUAL_ENV
       echo -n -s "(" (basename "$VIRTUAL_ENV") ") "
    end

    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end

    echo -n -s (set_color $color_cwd) "["(prompt_pwd)"]" (set_color normal) (__fish_git_prompt) (set_color -o brblue) " $suffix " (set_color normal)
end

function fish_title
    if string match -q $_ "fish"
      echo ready
    else
      echo $_
    end
    echo " " (prompt_pwd)
end

