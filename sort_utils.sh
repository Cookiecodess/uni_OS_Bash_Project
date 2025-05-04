#!/bin/bash

generate_unique_filename() {
    local filename="$1"
    local base="${filename%.*}"  # Get the base filename without extension
    local extension="${filename##*.}"  # Get the file extension
    local suffix=1

    # Check if the file exists and increment suffix until a unique filename is found
    while [[ -e "$filename" ]]; do
        filename="${base}_$suffix.$extension"
        ((suffix++))
    done

    echo "$filename"
}

print_msg_below_menu() {
    local msg="$1"
    local menu_lines=3

    tput rc # move cursor to first line of menu (saved at the start of draw_export_menu)

    # Move cursor down, to 2 lines below the menu
    tput cud $((menu_lines + 1))

    # Clear line in case a message was printed here before
    tput el

    echo -e "$msg"
}



draw_export_menu() {
    local options=("Export as neatly formatted TXT" "Export as raw data CSV\n" "Quit")
    local selected=0
    local menu_lines=${#options[@]}

    echo # spacing before the menu (you can adjust or insert a separator here)
    tput sc  # Save cursor position here

    while true; do
        tput rc  # Restore to saved cursor
        tput el  # Clear the current line
        for i in "${!options[@]}"; do
            tput el  # Clear line
            if [[ $i -eq $selected ]]; then
                echo -e "\033[7m> ${options[i]}\033[0m"  # Highlight selected option
            else
                echo -e "  ${options[i]}"
            fi
        done

        # Move cursor back up to the menu position
        for ((i=0; i<menu_lines; i++)); do
            tput cuu1
        done

        # Handle key press
        read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 -t 0.1 key2  # Read the rest of the escape sequence
            key+=$key2
        fi

        case "$key" in
            $'\x1b[A')  # up
                ((selected--))
                ((selected < 0)) && selected=$((menu_lines - 1))
                ;;
            $'\x1b[B')  # down
                ((selected++))
                ((selected >= menu_lines)) && selected=0
                ;;
            "")  # Enter
                tput cud1  # move cursor down 1 after menu
                case $selected in
                    0) 
                        export_as_table; 
                        continue
                        ;;
                    1) 
                        export_as_colon; 
                        continue 
                        ;;
                    2) 
                        # echo "Returning to menu..."; 
                        break 
                        ;;
                esac
                ;;
        esac
    done
}