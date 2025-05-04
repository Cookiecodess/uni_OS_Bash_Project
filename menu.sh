#!/bin/bash

# Customization vars
HEADER_TEXT=""
SHOW_HEADER=true
TEMP_MESSAGE=""
SHOW_TEMP_MESSAGE=false
MENU_ITEMS=()
SELECTED=0
MENU_PROMPT=">"

# Draws the header if enabled
menu_draw_header() {
    $SHOW_HEADER && echo -e "\033[1m$HEADER_TEXT\033[0m\n"
}

# Draws the header if enabled (fancy version)
menu_draw_fancy_header() {
    $SHOW_HEADER && {
        local text="$1"
        local width="${2:-$(tput cols)}"
        local padding_char="="

        local decorated="[ $text ]"
        local decorated_len=${#decorated}
        local total_pad=$((width - decorated_len))
        local pad_side=$((total_pad / 2))
        local pad_extra=$((total_pad % 2))

        printf '%*s' "$pad_side" '' | tr ' ' "$padding_char"
        printf '%s' "$decorated"
        printf '%*s\n\n' "$((pad_side + pad_extra))" '' | tr ' ' "$padding_char"
    }
}


# Displays a temporary message if $TEMP_MESSAGE is not empty
menu_draw_temp_message() {
    [[ -n $TEMP_MESSAGE ]] && echo -e "\033[33m$TEMP_MESSAGE\033[0m\n"
}

# Draws the menu items with cursor highlighting
menu_draw_items() {
    for i in "${!MENU_ITEMS[@]}"; do
        if [[ $i -eq $SELECTED ]]; then
            echo -e "\033[7m$MENU_PROMPT ${MENU_ITEMS[$i]}\033[0m"
        else
            echo "  ${MENU_ITEMS[$i]}"
        fi
    done
}

# Clears the terminal lines to prepare for redraw
menu_clear() {
    lines=$(( ${#MENU_ITEMS[@]} + ($SHOW_HEADER ? 1 : 0) + ($SHOW_TEMP_MESSAGE ? 1 : 0) ))
    for _ in $(seq 1 $lines); do echo -en "\033[1A\033[2K"; done
}

# Handles the keypress loop
menu_loop() {
    tput civis  # hide cursor
    trap "tput cnorm; exit" INT TERM EXIT  # show cursor on exit, Ctrl+C, etc.

    while true; do
        clear # clear screen
        # menu_draw_header
        menu_draw_fancy_header "$HEADER_TEXT" 50    # second arg (width) is optional; if not given, header fills console width
        menu_draw_temp_message
        menu_draw_items

        # read multibyte sequence (arrow keypresses)
        IFS= read -rsn1 key
        [[ $key == $'\x1b' ]] && {
            read -rsn2 -t 0.1 key2      # 0.1s timeout to achieve non-blocking read
            key+="$key2"
        }

        # change $SELECTED based on key pressed
        case "$key" in
            $'\x1b[A') # Up
                ((SELECTED--))
                ((SELECTED < 0)) && SELECTED=$((${#MENU_ITEMS[@]} - 1))
                ;;
            $'\x1b[B') # Down
                ((SELECTED++))
                ((SELECTED >= ${#MENU_ITEMS[@]})) && SELECTED=0
                ;;
            "") # Enter
                return $SELECTED
                ;;
        esac

        menu_clear
    done
}

# Main wrapper to run the menu
draw_menu() {
    HEADER_TEXT="$1"
    # SHOW_HEADER="$2"
    # SHOW_TEMP_MESSAGE="$2"
    # TEMP_MESSAGE="$2"
    shift 1    # shift remaining args to $1, $2, ...
    MENU_ITEMS=("$@")

    SELECTED=0
    menu_loop
}

# menu "$@" 

# example use:
# menu "Main Menu" "Register" "Login" "Exit"