#!/bin/sh
# shell script to prepend i3status with cmus song and artist

stop_s="◾"
play_s="▶"
pause_s="Ⅱ"

i3status | while :
do
        read line
        status=$(cmus-remote -Q 2> /dev/null | grep 'status' | cut -d ' ' -f2-)

        if [ -z "$status" ]
        then
            echo "$line " || exit 1
        else
            case "$status" in
                "stopped")
                    symbol="$stop_s"
                    ;;
                "playing")
                    symbol="$play_s"
                    ;;
                "paused")
                    symbol="$pause_s"
                    ;;
            esac

            artist=$(cmus-remote -Q | grep ' artist ' | cut -d ' ' -f3-)
            song=$(cmus-remote -Q | grep title | cut -d ' ' -f3-)

            echo "$symbol  $artist - $song | $line " || exit 1
        fi
done

