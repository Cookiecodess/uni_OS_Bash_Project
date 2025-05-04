#!/bin/bash

source utils.sh

patron_file="patron.txt"
TEMP_MSG=""

# For reference, here's the data structure of patron.txt:
# ID:Last Name:First Name:Mobile Number:Joined Date:Membership Type

# Skip first line (header row) in patron.txt,
# then sort by Last Name (2nd field)
sorted=$(tail -n +2 "$patron_file" | sort -t ':' -k3,3)

# Extract fields into arrays for length calculation
last_names=()
first_names=()
mobiles=()
dates=()
types=()

while IFS=':' read -r id first last mobile birth type joined; do
    last_names+=("$last")
    first_names+=("$first")
    mobiles+=("$mobile")
    dates+=("$joined")
    types+=("$type")
done <<< "$sorted"

# Determine max width for each column
maxlen() {
    local max=0
    for str in "${@:2}"; do
        (( ${#str} > max )) && max=${#str}
    done
    echo $(( max > ${#1} ? max : ${#1} ))
}

w_last=$(maxlen "Last Name" "${last_names[@]}")
w_first=$(maxlen "First Name" "${first_names[@]}")
w_mobile=$(maxlen "Mobile Number" "${mobiles[@]}")
w_date=$(maxlen "Joined Date" "${dates[@]}")
w_type=$(maxlen "Membership Type" "${types[@]}")

export_as_table() {
    local today=$(date +%d-%m-%Y)
    local outfile="patrons_sorted_lname_${today}.txt"

    # Generate unique filename if the file already exists
    outfile=$(generate_unique_filename "$outfile")

    {
        printf "%-*s  %-*s  %-*s  %-*s  %-*s\n" \
            "$w_last" "Last Name" \
            "$w_first" "First Name" \
            "$w_mobile" "Mobile Number" \
            "$w_date" "Joined Date" \
            "$w_type" "Membership Type"
        for i in "${!last_names[@]}"; do
            printf "%-*s  %-*s  %-*s  %-*s  %-*s\n" \
                "$w_last" "${last_names[i]}" \
                "$w_first" "${first_names[i]}" \
                "$w_mobile" "${mobiles[i]}" \
                "$w_date" "${dates[i]}" \
                "$w_type" "${types[i]}"
        done
    } > "$outfile"

    print_msg_below_menu "${GREEN}Exported table to $outfile! :)${RESET}"
}

export_as_colon() {
    local today=$(date +%d-%m-%Y)
    local outfile="patrons_sorted_lname_${today}.csv"

    # Generate unique filename if the file already exists
    outfile=$(generate_unique_filename "$outfile")

    tail -n +2 "$patron_file" | sort -t ':' -k3,3 > "$outfile"

    print_msg_below_menu "${GREEN}Exported colon-separated data to $outfile! :)${RESET}"
}

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
    local options=("Export as neatly formatted TXT" "Export as raw data CSV" "Quit")
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
                echo "  ${options[i]}"
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


# clear screen and hide cursor
clear
tput civis

# Print header
printHeader "Patron Details Sorted by Last Name" "\033[1;34m" $((w_last + w_first + w_mobile + w_date + w_type + 16))

# Print column headers in bold
printf "\033[1m%-*s  %-*s  %-*s  %-*s  %-*s\033[0m\n" \
  "$w_last" "Last Name" \
  "$w_first" "First Name" \
  "$w_mobile" "Mobile Number" \
  "$w_date" "Joined Date" \
  "$w_type" "Membership Type"

# Print patron data
for i in "${!last_names[@]}"; do
    printf "%-*s  %-*s  %-*s  %-*s  %-*s\n" \
      "$w_last" "${last_names[i]}" \
      "$w_first" "${first_names[i]}" \
      "$w_mobile" "${mobiles[i]}" \
      "$w_date" "${dates[i]}" \
      "$w_type" "${types[i]}"
done

# Print selection menu
draw_export_menu

# show cursor on exit
tput cnorm
