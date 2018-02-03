# Aliases
alias m "python manage.py"
alias you-mp3 "youtube-dl -x --audio-format mp3 --audio-quality 0"

function forecast
  curl -4 "http://wttr.in/$argv"
end


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


set __fish_preexec_command ""
set __fish_preexec_timestamp (date +'%s')
set __fish_preexec_status 0


function preexec --on-event fish_preexec
  set __fish_preexec_command $argv
  set __fish_preexec_timestamp (date +'%s')
end


function postexec --on-event fish_postexec
  set __fish_preexec_status $status
end

function sec_to_human
    set -l H ""
    set -l M ""
    set -l S ""

    set -l h (math $argv[1] / 3600)
    if test $h -gt 0
        set H "$h hour"
        if test $h -gt 1
           set H (string join "" "$H" "s")
        end
    end

    set -l m (math $argv[1] / 60 \% 60)
    if test $m -gt 0
        set M "$m min"
        if test $m -gt 1
           set M (string join "" "$M" "s")
        end
    end

    set -l s (math $argv[1] \% 60)
    if test $s -gt 0
        set S "$s sec"
        if test $s -gt 1
           set S (string join "" "$S" "s")
        end
    end

    echo (echo $H $M $S | tr -s " ")
end

function fish_prompt --description 'Write out the prompt'
    set -l color_cwd
    set -l suffix
    set -l sec_num 5

    if test $CMD_DURATION -ge (math "1000 * $sec_num")
       set -l command_time (math (date +'%s') - $__fish_preexec_timestamp)
       set command_time (sec_to_human $command_time)

       set -l icon "terminal"
       if test $__fish_preexec_status -ne 0
         set icon "dialog-error"
       end
       mpv /usr/share/sounds/freedesktop/stereo/complete.oga --really-quiet & \
         notify-send -i $icon "Long command completed" "$__fish_preexec_command\nTook $command_time"
    end

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

