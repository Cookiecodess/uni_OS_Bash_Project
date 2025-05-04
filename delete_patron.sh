#!/bin/bash

source ./utils.sh

# tput civis     # hide cursor

# make an array of patron IDs from patron.txt (skipping the header)
patrons=($(tail -n +2 patron.txt | cut -d: -f1)) # "+2": start from line 2. 
                                                 # "cut -d:" split by delimiter colon (:)
                                                 # "-f1" grab field 1 (PatronID)
search=""
highlight=0

function filter_patrons() {
    filtered=()
    for id in "${patrons[@]}"; do
        # convert both $id and $search to lowercase for case-insensitive search
        if [[ "${id,,}" == *"${search,,}"* ]]; then
            filtered+=("$id")
        fi
    done
    [[ $highlight -ge ${#filtered[@]} ]] && highlight=0 
}

function find_entry_by_id() {
    target_id="$1"
    filename="$2"

    while IFS= read -r line; do
        first_field="${line%%:*}"  # Extract the part before the first colon
        if [[ "$first_field" == "$target_id" ]]; then
            echo "$line"
        fi
    done < "$filename"
}

function display_patron_info() {
    # print nothing if no results found
    [[ ${#filtered[@]} -eq 0 ]] && return

    # get patron entry corresponding to highlighted patron ID
    entry=$(find_entry_by_id "${filtered[$highlight]}" "patron.txt")

    # split line by colon (:) and assign data to corresponding variables
    IFS=':' read -r id fname lname mobile birth type joined <<< "$entry"

    echo -e "\n${CYAN}Patron Details:${RESET}"
    printf "%-15s %s\n" "Patron ID" "$id"
    printf "%-15s %s\n" "First Name" "$fname"
    printf "%-15s %s\n" "Last Name" "$lname"
    printf "%-15s %s\n" "Mobile Number" "$mobile"
    printf "%-15s %s\n" "Birth Date" "$birth"
    printf "%-15s %s\n" "Type" "$type"
    printf "%-15s %s\n" "Joined Date" "$joined"
}

function draw_screen() {
    clear
    printHeader "Delete a Patron" 

    echo -n "Search Patron ID (type 'q' to quit): $search"
    tput sc # save cursor position
    echo -e "\nHit ENTER to delete."
    echo

    if [[ ${#filtered[@]} -eq 0 ]]; then
        echo "No results found."
        tput rc # restore cursor position (so it appears at the search field)
        tput cnorm # show cursor after teleporting it back to search field, creating the illusion it's always been there ;)
        return
    fi

    for i in "${!filtered[@]}"; do
        if [[ $i -eq $highlight ]]; then
            echo -e "> \e[7m${filtered[$i]}\e[0m"
        else
            echo "  ${filtered[$i]}"
        fi
    done

    display_patron_info

    tput rc # restore cursor position (so it appears at the search field)
    tput cnorm # show cursor after teleporting it back to search field, creating the illusion it's always been there ;)
}

# Color definitions
CYAN='\033[36m'
RESET='\033[0m'

# filter patrons
filter_patrons

# initial draw
draw_screen

# draw loop 
while true; do
    IFS= read -rsn1 key

    tput civis  # hide cursor so no flashing cursor during the redrawing of screen

    # Handle multi-byte sequences (arrow keys)
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 rest
        key+="$rest"
    fi

    case "$key" in
        $'\x1b[A')  # Up
            ((highlight--))
            ((highlight < 0)) && highlight=$((${#filtered[@]} - 1))
            ;;
        $'\x1b[B')  # Down
            ((highlight++))
            ((highlight >= ${#filtered[@]})) && highlight=0
            ;;
        $'\x7f')  # Backspace
            [[ -n $search ]] && search="${search::-1}"  # only remove one character off of $search if it isn't already empty
            highlight=0
            ;;
        $'')  # Enter
            clear
            if [[ ${#filtered[@]} -gt 0 ]]; then
                id="${filtered[$highlight]}"
                tput cnorm # show cursor
                echo -e "\nAre you sure you want to delete $id? \nType \"yes\" to confirm, or anything else to cancel"
                read -r confirm
                echo ""
                if [[ "${confirm,,}" == "yes" ]]; then
                    # Delete line from file
                    grep -v "^$id:" patron.txt > tmpfile && mv tmpfile patron.txt
                    echo "$id deleted."
                    sleep 1
                    patrons=($(tail -n +2 patron.txt | cut -d: -f1))
                    search=""
                    highlight=0
                else
                    echo "Cancelled."
                    sleep 1
                fi
            fi
            ;;

        *)
            if [[ "$key" =~ [[:print:]] ]]; then    # `[[:print:]]` matches any printable character
                search+="$key"
                highlight=0
                if [[ "${search,,}" == "q" ]]; then   # Exit this page if enter 'q' or 'Q'
                    echo -e "\nQuitting."
                    tput cnorm     # show cursor
                    break
                fi
            fi
            ;;
    esac

    filter_patrons
    draw_screen
done
