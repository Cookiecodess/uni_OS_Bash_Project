#!/bin/bash

source utils.sh
source sort_utils.sh

patron_file="patron.txt"
TEMP_MSG=""

# Skip header and sort by Joined Date (6th field)
sorted=$(tail -n +2 "$patron_file" | sort -t ':' -k6,6)

# Extract relevant fields into arrays
ids=()
last_names=()
first_names=()
mobiles=()
dates=()
# types=()

while IFS=':' read -r id first last mobile birth type joined; do
    ids+=("$id")
    last_names+=("$last")
    first_names+=("$first")
    mobiles+=("$mobile")
    dates+=("$joined")
done <<< "$sorted"

# Calculate max widths
maxlen() {
    local max=0
    for str in "${@:2}"; do
        (( ${#str} > max )) && max=${#str}
    done
    echo $(( max > ${#1} ? max : ${#1} ))
}

w_id=$(maxlen "Patron ID" "${ids[@]}")
w_last=$(maxlen "Last Name" "${last_names[@]}")
w_first=$(maxlen "First Name" "${first_names[@]}")
w_mobile=$(maxlen "Mobile Number" "${mobiles[@]}")
w_date=$(maxlen "Joined Date" "${dates[@]}")
# w_type=$(maxlen "Membership Type" "${types[@]}")

export_as_table() {
    local today=$(date +%d-%m-%Y)
    local outfile="patrons_sorted_joined_${today}.txt"
    outfile=$(generate_unique_filename "$outfile")

    {
        printf "%-*s  %-*s  %-*s  %-*s  %-*s\n" \
            "$w_id" "Patron ID" \
            "$w_last" "Last Name" \
            "$w_first" "First Name" \
            "$w_mobile" "Mobile Number" \
            "$w_date" "Joined Date"
        for i in "${!ids[@]}"; do
            printf "%-*s  %-*s  %-*s  %-*s  %-*s\n" \
                "$w_id" "${ids[i]}" \
                "$w_last" "${last_names[i]}" \
                "$w_first" "${first_names[i]}" \
                "$w_mobile" "${mobiles[i]}" \
                "$w_date" "${dates[i]}" 
        done
    } > "$outfile"

    print_msg_below_menu "${GREEN}Exported table to $outfile! :)${RESET}"
}

export_as_colon() {
    local today=$(date +%d-%m-%Y)
    local outfile="patrons_sorted_joined_${today}.csv"
    outfile=$(generate_unique_filename "$outfile")

    tail -n +2 "$patron_file" | sort -t ':' -k6,6 > "$outfile"

    print_msg_below_menu "${GREEN}Exported colon-separated data to $outfile! :)${RESET}"
}


# clear screen and hide cursor
clear
tput civis

# Print header
printHeader "Patron Details Sorted by Joined Date (Newest to Oldest)" "\033[1;34m" $((w_id + w_last + w_first + w_mobile + w_date + 20))

# Print column headers in bold
printf "\033[1m%-*s  %-*s  %-*s  %-*s  %-*s\033[0m\n" \
  "$w_id" "Patron ID" \
  "$w_last" "Last Name" \
  "$w_first" "First Name" \
  "$w_mobile" "Mobile Number" \
  "$w_date" "Joined Date"

# Print patron data
for i in "${!dates[@]}"; do
    printf "%-*s  %-*s  %-*s  %-*s  %-*s\n" \
      "$w_id" "${ids[i]}" \
      "$w_last" "${last_names[i]}" \
      "$w_first" "${first_names[i]}" \
      "$w_mobile" "${mobiles[i]}" \
      "$w_date" "${dates[i]}"
done

# Print selection menu
draw_export_menu

# show cursor on exit
tput cnorm