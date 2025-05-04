#!/bin/bash

# Include guard
if [[ -n "$__UTILS_SH_INCLUDED__" ]]; then
    # If sourced in another script: return, else (probably ran directly in cli): exit
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return || exit 0
fi
export __UTILS_SH_INCLUDED__=true

# color constants
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
RESET='\033[0m'


# general functions
function printHeader() {
    local header="$1"
    local color="${2:-}"       # optional: if not passed in, just print plain
    local width="${3:-50}"     # default width is 28 unless caller says otherwise

    # if header is longer than the box, make the box bigger
    if (( width < ${#header} )); then
        width=$(( ${#header} + 4 ))  # add some breathing room
    fi

    # make the top/bottom border: just a row of '=' chars
    local border=$(printf '=%.0s' $(seq 1 "$width"))

    # figure out how many spaces to put before the header to center it
    local padding=$(( (width - ${#header}) / 2 ))
    local spaces=$(printf '%*s' "$padding" '')

    # if color is passed, use it for borders and header
    if [[ -n "$color" ]]; then
        echo -e "${color}${border}\033[0m"
        echo -e "${spaces}${color}${header}\033[0m"
        echo -e "${color}${border}\033[0m"
    else
        echo "$border"
        echo "${spaces}${header}"
        echo "$border"
    fi

    echo # extra newline after header
}


function waitMessage() {
    echo -e "\nPress any key to continue..."
    read -r -n1 -s
}

# sound
beep() {
    echo -e "\a"
    sleep "$1"
}

# INPUT VALIDATION AND INPUT HANDLING FUNCTIONS

# ===== Notes on returning strings from functions: =====
# if you do this:
#       return=$(func)
# then all echo commands in func go to stdout, which in this case is NOT the console screen, but to $return.
# To actually print stuff inside func, you must append ">&2" to the echo command.
# It tells echo to redirect the data to stderr instead of stdout, which means, 
# "yo, show up on the terminal screen, but you will NOT be the output of the function".

INTRP_SIG=-999 #interrupt signal, output by input-validating functions

# Usage:
# get_confirm_input "Do you want to continue? (y/n): " "y Y" "n N" "Please enter y or n."
# [ $? -eq 0 ] means accepted, [ $? -eq 1 ] means interrupted
get_valid_input_by_set() {
    local prompt="$1"
    local accept_str="$2"
    local interrupt_str="$3"
    local error_msg="$4"
    local input

    while true; do
        read -rp "$prompt" input

        # If input is in the accepted list
        for word in $accept_str; do
            if [[ "$input" == "$word" ]]; then
                echo -en "\033[2K" >&2 # Clear error line in case it was printed
                echo "$input" #return valid input
                return 0  # accepted
            fi
        done

        # If input is in the interrupt list
        for word in $interrupt_str; do
            if [[ "$input" == "$word" ]]; then
                echo -en "\033[2K" >&2 # Clear error line in case it was printed
                echo $INTRP_SIG # return interrupt signal
                return 1  # interrupted
            fi
        done

        # Not accepted or interrupted, so show error
        echo -n "$error_msg" >&2
        echo -en "\033[1A\033[2K\033[1G" >&2 # Move up 1 line, clear it completely, and move to column 1
    done
}

# currently not interruptable
get_valid_input_by_func() {
    local prompt="$1"
    local validation_fn="$2"  # The validation function's name passed as a string
    local error_msg="$3"
    local input

    while true; do
        read -rp "$prompt" input

        # Call the validation function (it should return 0 for valid input)
        if "$validation_fn" "$input"; then
            echo -en "\033[2K" >&2 # Clear error line in case it was printed (>&2 redirects this ANSI string to stderr instead of stdout so it doesn't get "returned" but still printed on screen)
            echo "$input" # our "return value" ($(get_valid_input) will evaluate to this)
            return 0
        else
            echo -n "$error_msg" >&2 # ()>&2 to print on screen but do not return)
            echo -en "\033[1A\033[2K\033[1G" >&2 # Move up 1 line, clear it completely, and move to column 1
        fi
    done
}

# Phone validation function
validate_phone_number() {
    local phone="$1"
    if [[ "$phone" =~ ^01[0-9]-[0-9]{8}$ ]]; then
        return 0 # true (yes, 0 is true. weird, i know)
    else
        return 1 # false
    fi
}

# Date validation function
validate_date() {
    local date="$1"
    if [[ "$date" =~ ^[0-1][0-9]-[0-3][0-9]-[0-9]{4}$ ]]; then
        return 0 # true (yes, 0 is true. weird, i know)
    else
        return 1 # false
    fi
}

# Calling the function and capturing the output (the valid string)
# date=$(get_valid_input_by_func "Enter your date: " validate_date "Invalid date. Please enter a valid date.")

# Using get_valid_input_by_set, interruptable by entering "q" or "Q"
# membershipType=$(get_valid_input_by_set "Enter membership: " "Student Public" "q Q" "Must be Student or Public.")
# if [[ "$membershipType" -eq $INTRP_SIG ]]; then
#     echo "End!"
#     exit 0
# fi
# echo "Membership type: $membershipType"




