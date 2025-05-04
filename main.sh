#!/bin/bash

source ./utils.sh

# printHeader(), waitMessage(), beep() are now defined in utils.sh

# color
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
RESET='\033[0m'

# password and name
CORRECT_USER="admin"
CORRECT_PASS="123"

#only can this few time to login fail
MAX_ATTEMPTS=3
attempts=0



# login page

# function printHeader() {
#     clear
#     echo -e "\t ${choices[$key]}!"
#     echo -e "===================================================="

# }

PATRON_FILE="patron.txt"
function addNew() {

    continue="y"
    while [[ "$continue" == "y" ]]; do
        clear
        printHeader "Add New Patron Details" 
    while true; do
        read -r -p "Patron ID (format P****): " pID

        if [[ ! "$pID" =~ ^P[0-9]{4}$ ]]; then
            echo -e "Invalid Patron ID format. Please use 'P****' format."
            continue
        fi

        if grep -q "^$pID:" "$PATRON_FILE"; then
            echo -e "Patron ID already exists."
            continue
        fi

        break  # valid and unique ID
    done
        read -r -p "First Name:" fname
        while [[ -z "$fname" ]]; do
            echo -e "Sorry the First Name cannot left blank."
            read -r -p "First Name:" fname
        done
        read -r -p "Last Name:" lname
        while [[ -z "$lname" ]]; do
            echo -e "Sorry the Last Name cannot left blank."
            read -r -p "Last Name:" lname
        done
        read -r -p "Mobile Number(01#-########):" phnum
        while ! [[ "$phnum" =~ ^01[0-9]{1}-[0-9]{7,8}$ ]]; do
            echo -e "Sorry the Phone Number Format is wrong."
            read -r -p "Mobile Number:" phnum
        done
        read -r -p "Birth Date (MM-DD-YYYY):" bdate
        while ! [[ "$bdate" =~ ^[0-1][0-9]-[0-3][0-9]-[0-9]{4}$ ]]; do
            echo -e "Sorry the Birth Date Format is wrong."
            read -r -p "Birth Date (MM-DD-YYYY):" bdate
        done
        read -r -p "Membership type (Student / Public):" memberType
        while [[ "$memberType" != "Student" && "$memberType" != "Public" ]]; do

            echo -e "Sorry Please Select (Student/Public)."
            read -r -p "Membership type (Student / Public):" memberType
        done
        read -r -p "Joined Date (MM-DD-YYYY):" joinedDate
        while ! [[ "$joinedDate" =~ ^[0-1][0-9]-[0-3][0-9]-[0-9]{4}$ ]]; do
            echo -e "Sorry the Joined Date Format is wrong."
            read -r -p "Joined Date (MM-DD-YYYY):" joinedDate
        done

        echo "Press (q) to return to Patron Maintenance Menu."
        read -p "Add another new patron details? (y)es or (q)uit :" continue
        while ! [[ "$continue" == "y" || "$continue" == "q" ]]; do
            echo -e "Sorry you selection is invalid.Please try again."
            read -p "Press (q) to return to Patron Maintenance Menu." continue
        done

        #  if [ "$continue" == "q" ];
        #     then echo "yes"
        # fi
        #echo -e "PatronID:FName:LName:MobileNum:BirthDate:Type:JoinedDate">>patron.txt
        echo -e "$pID:$fname:$lname:$phnum:$bdate:$memberType:$joinedDate" >>patron.txt

    done
    menu
}

function searchPatron() {
    # clear
    # echo "Search Patron Details"
    
    continue="y"
    while [[ "$continue" == "y" ]]; do
	    clear
	    printHeader "Search Patron Details"
        read -r -p "Enter Patron ID: " id
        id=${id^^}
        line=$(grep "^$id:" patron.txt)

        #if line found
        if [[ -n "$line" ]]; then
            IFS=: read -r id fname lname phone bdate member jdate <<< "$line"

            clear
    	    printHeader "Patron Found!"

            # echo "Patron Found!"
            # echo "==========================="
            echo "Patron ID: $id"
            echo "First Name: $fname"
            echo "Last Name: $lname"
            echo "Mobile Number: $phone"
            echo "Birth Date (DD-MM-YYYY): $bdate"
            echo "Membership Type (Student/Public): $member"
            echo "Joined Date (DD-MM-YYYY): $jdate"
        else
            clear
    	    printHeader "No Patron with ID $id Found!"
        fi

        printf "\nPress (q) to return to Patron Maintenance Menu.\n\n"

        read -n 1 -s -p "Search another patron? (y)es or (q)uit: " choice
        if [[ "${choice,,}" == "y" ]]; then
            searchPatron
        elif [[ "${choice,,}" == "q" ]]; then
            menu
        fi

    done
}

function updatePatron() {
    # clear
    # echo "Update a Patron Details"
    choice="y"
    while [[ "$choice" == "y" ]]; do
        clear
        printHeader "Update a Patron Details"

        # clear
        # echo "Update a Patron Details"
        read -p "Enter Patron ID: " id
        id=${id^^}

        line=$(grep "^$id:" patron.txt)

        #if line found
        if [[ -n "$line" ]]; then
            IFS=: read -r id fname lname phone bdate member jdate <<<"$line"

            clear
	    printHeader "Patron Found!"
            echo "Patron ID: $id"
            echo "First Name: $fname"
            echo "Last Name: $lname"

            while true; do
                read -e -i $phone -p "Mobile Number: " newphone
                if [[ $newphone =~ (^01[2-9]-[0-9]{7}$)|(^011-[0-9]{8}$) ]]; then
                    clear
	    	    printHeader "Patron Found!"
                    echo "Patron ID: $id"
                    echo "First Name: $fname"
                    echo "Last Name: $lname"
                    echo "Mobile Number: $newphone"
                    break
                else
                    clear
	            printHeader "Patron Found!"
                    echo "Patron ID: $id"
                    echo "First Name: $fname"
                    echo "Last Name: $lname"
                    echo "Invalid Phone Format!"
                fi
            done

            while true; do
                read -e -i $bdate -p "Birth Date (DD-MM-YYYY): " newdate
                if [[ $newdate =~ ^(0[1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])-[0-9]{4}$ ]]; then
                    clear
	            printHeader "Patron Found!"
                    echo "Patron ID: $id"
                    echo "First Name: $fname"
                    echo "Last Name: $lname"
                    echo "Mobile Number: $newphone"
                    echo "Birth Date (DD-MM-YYYY): $newdate"
                    break
                else
                    clear
	            printHeader "Patron Found!"
                    echo "Patron ID: $id"
                    echo "First Name: $fname"
                    echo "Last Name: $lname"
                    echo "Mobile Number: $newphone"
                    echo "Invalid Date Format!"
                fi
            done

            echo "Membership Type (Student/Public): $member"
            echo "Joined Date (DD-MM-YYYY): $jdate"

            printf "\nPress (q) to return to Patron Maintenance Menu.\n\n"

            read -n 1 -s -p "Are you sure you want to UPDATE the above Patron Details? (y)es or press any key to quit: " choice
            if [[ "${choice,,}" == "y" ]]; then
                sed -i "/^$id:/s/.*/$id:$fname:$lname:$newphone:$newdate:$member:$jdate/" patron.txt
            fi
	    choice="q"

        else
            clear
	    printHeader "No Patron with ID $id Found!"

            read -n 1 -s -p "Press (y) to continue or press any key to return to Patron Maintenance Menu." choice
            # if [[ "${choice,,}" == "q" ]]; then
            #     menu
            # else
            # "$choice" == "y"
            # fi
        fi

    done

}

# function menu() {
#     while true; do
#         clear
#         echo -e "${GREEN}==========================================================="
#         echo -e "\t Patron Maintenance Menu"
#         echo -e "===========================================================${RESET}"
#         declare -a keys=("A" "S" "U" "D" "L" "P" "J" "Q")
#         declare -A choices
#         choices["A"]="Add New Patron Details"
#         choices["S"]="Search a Patron (by Patron ID)"
#         choices["U"]="Update a Patron Details"
#         choices["D"]="Delete a Patron Details"
#         choices["L"]="Sort Patrons by Last Name"
#         choices["P"]="Sort Patrons by Patron ID"
#         choices["J"]="Sort Patrons by Joined Date (Newest to Oldest Date)"
#         choices["Q"]="Exit from Program"

#         for key in "${keys[@]}"; do
#             if [ "$key" == "Q" ]; then
#                 echo -e ""
#             fi
#             echo "$key - ${choices[$key]}"

#         done

#         read -r -p "Please select a choice:" key

#         key=${key^^}

#         if [ "$key" == "A" ]; then #     if [ "$key" == "A" ] || [ "$key" == "a" ];
#             addNew

#         elif [ "$key" == "S" ]; then

#             searchPatron

#         elif [ "$key" == "U" ]; then

#             updatePatron
#         elif [ "$key" == "D" ]; then
#             ./delete_patron.sh

#         elif [ "$key" == "L" ]; then
#             clear
#             printHeader "${choices[$key]}"
#         elif [ "$key" == "P" ]; then
#             clear
#             printHeader "${choices[$key]}"
#         elif [ "$key" == "J" ]; then
#             clear
#             printHeader "${choices[$key]}"

#         elif [ "$key" == "Q" ]; then
#             echo -e "\nGoodbye!"
#             exit 0

#         else
#             echo "Invalid choice: $key"
#             waitMessage
#             # menu
#         fi
#     done
# }

function menu() {
    source ./menu.sh
    main_menu_options=(
        "Add New Patron Details"
        "Search a Patron (by Patron ID)"
        "Update a Patron Details"
        "Delete a Patron Details"
        "Sort Patrons by Last Name"
        "Sort Patrons by Patron ID"
        "Sort Patrons by Joined Date (Newest to Oldest Date)\n"
        "Exit from Program"
    )

    while true; do
        draw_menu "Patron Maintenance Menu" "${GREEN}" "${main_menu_options[@]}" 
        case "$SELECTED" in
            0)
                addNew
                ;;
            1)
                searchPatron
                ;;
            2)
                updatePatron
                ;;
            3)
                bash delete_patron.sh 
                ;;
            4)
                bash sort_patron_lname.sh
                ;;
            5)
                bash sort_patron_id.sh
                ;;
            6)
                bash sort_patron_joined.sh
                ;;
            7)
                echo "Goodbye!"
                exit 1
                break
                ;;
            *)
                TEMP_MESSAGE="Invalid selection: $SELECTED"
                ;;
        esac
    done
}

function login() {
    clear
    # echo -e "${CYAN}======================================="
    # echo -e "      Welcome to Linux Secure Login     "
    # echo -e "=======================================${RESET}"
    printHeader "Welcome to Linux Secure Login" "${CYAN}"
    # echo

    while [ $attempts -lt $MAX_ATTEMPTS ]; do
        echo -ne "${BLUE}Username: ${RESET}" #n = no next line
        read username

        echo -ne "${BLUE}Password: ${RESET}"
        read -s password #hiden the password
        echo

        echo -e "${YELLOW}Verifying credentials...${RESET}"
        sleep 2

        if [[ "$username" == "$CORRECT_USER" && "$password" == "$CORRECT_PASS" ]]; then
            echo
            echo -e "${GREEN}======================================="
            echo -e "Login successful. Welcome, $username!"
            echo -e "=======================================${RESET}"

            # a long sound
            beep 0.2
            beep 0.2
            sleep 0.1
            beep 0.2
            beep 0.2
            sleep 0.1
            beep 0.4
            sleep 0.3
            beep 0.2
            beep 0.2
            sleep 0.1
            beep 0.4

            echo
            echo -e "${CYAN}Enjoy your session!${RESET}"
            menu
        else
            echo
            echo -e "${RED}Login failed: Incorrect username or password.${RESET}"
            attempts=$((attempts + 1))
            if [ $attempts -lt $MAX_ATTEMPTS ]; then
                echo -e "${YELLOW}Please try again. Attempts left: $((MAX_ATTEMPTS - attempts))${RESET}"
                echo
                sleep 1
            fi
        fi
    done

    echo
    echo -e "${RED}======================================="
    echo -e "Account locked due to too many failed attempts."
    echo -e "Please contact the system administrator."
    echo -e "=======================================${RESET}"
    exit 1

}

# menu

login
