#!/bin/bash

source utils.sh
source sort_utils.sh

patron_file="patron.txt"
TEMP_MSG=""

# For reference, here's the data structure of patron.txt:
# PatronID:FName:LName:MobileNum:BirthDate:Type:JoinedDate

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
