#!/bin/bash

draw_splash() {
    local title="${1:-Welcome}"
    local subtitle="${2:-Press any key to continue...}"
    local width="${3:-$(tput cols)}"
    local height="${4:-$(tput lines)}"

    tput civis
    clear

    local center_y=$((height / 2 - 1))
    local title_line="[ $title ]"
    local subtitle_line="$subtitle"

    local title_len=${#title_line}
    local subtitle_len=${#subtitle_line}

    local title_x=$(( (width - title_len) / 2 ))
    local subtitle_x=$(( (width - subtitle_len) / 2 ))

    for ((i=0; i<center_y-1; i++)); do echo ""; done

    printf "%*s\n" "$title_x" ""
    printf "%*s%s\n" "$title_x" "" "$title_line"
    printf "\n"
    printf "%*s%s\n" "$subtitle_x" "" "$subtitle_line"

    read -rsn1  # Wait for any key
    clear
    tput cnorm
}


draw_splash "My Cool App" "Use arrow keys to navigate"