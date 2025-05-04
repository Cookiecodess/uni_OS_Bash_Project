#!/bin/bash

clear
tput civis

rows=$(tput lines)
cols=$(tput cols)

# (what the logo should look like)
# '       _             '
# '      / \\   ____    '
# '     / _ \\ |   //   '
# '    / ___ \\| ||     '
# '   /_/   \_\|_//     '
# '                     '
# '     A R K I V E     '
logo=(
'       _               '
'      / \\\\   ____    '
'     / _ \\\\ |   //   '
'    / ___ \\\\| ||     '
'   /_/   \\_\\|_//     '
'                     '
'     A R K I V E     '
)

slogan="Tracking with style :)"
instruction="Press any key to start..."

# Total vertical space needed
total_lines=$(( ${#logo[@]} + 2 + 1 ))
start_row=$(( (rows - total_lines) / 2 ))

# Print logo centered
for i in "${!logo[@]}"; do
    line="${logo[$i]}"
    padding=$(( (cols - ${#line}) / 2 ))
    tput cup $((start_row + i)) $padding
    echo -e "\033[1;36m$line\033[0m"
done

# Print slogan
slogan_row=$((start_row + ${#logo[@]} + 1))
slogan_padding=$(( (cols - ${#slogan}) / 2 ))
tput cup $slogan_row $slogan_padding
echo -e "\033[1;32m$slogan\033[0m"

# Print instruction
instruction_row=$((slogan_row + 2))
instruction_padding=$(( (cols - ${#instruction}) / 2 ))
tput cup $instruction_row $instruction_padding
echo -e "\033[0;37m$instruction\033[0m"

# Wait for any key
read -n 1 -s

tput cnorm
clear
