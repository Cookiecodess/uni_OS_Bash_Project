#!/bin/bash

function printHeader() {
    clear
    echo -e "\t\t ${choices[$key]}!"
    echo -e "==================================="

}
function waitMessage() {
    echo -e "\nPress any key to continue..."
    read -r -n1 -s
}
function addNew() {
    continue="y"
    while [[ "$continue" == "y" ]]; do
        read -r -p "Patron ID:" pID
        while [[ -z "$pID" ]]; do
            echo -e "Sorry the Patron ID cannot left blank."
            read -r -p "Patron ID:" pID
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
        read -r -p "Add another new patron details? (y)es or (q)uit :" continue
        #  if [ "$continue" == "q" ];
        #     then echo "yes"
        # fi
        #echo -e "PatronID:FName:LName:MobileNum:BirthDate:Type:JoinedDate">>patron.txt
        echo -e "$pID:$fname:$lname:$phnum:$bdate:$memberType:$joinedDate" >>patron.txt
        menu
    done

}

function searchPatron() {
    # clear
    # echo "Search Patron Details"
    read -r -p "Enter Patron ID: " id
    id=${id^^}
    line=$(grep "^$id:" patron.txt)

    #if line found
    if [[ -n "$line" ]]; then
        IFS=: read -r -r id fname lname phone bdate member jdate <<<"$line"

        clear

        echo "Patron Found!"
        echo "==========================="
        echo "Patron ID: $id"
        echo "First Name: $fname"
        echo "Last Name: $lname"
        echo "Mobile Number: $phone"
        echo "Birth Date (DD-MM-YYYY): $bdate"
        echo "Membership Type (Student/Public): $member"
        echo "Joined Date (DD-MM-YYYY): $jdate"
    else
        clear
        echo "No Patron with ID $id Found!"
    fi

    printf "\nPress (q) to return to Patron Maintenance Menu.\n\n"

    read -r -n 1 -s -p "Search another patron? (y)es or (q)uit: " choice
    if [[ "${choice,,}" == "y" ]]; then
        searchPatron
    elif [[ "${choice,,}" == "q" ]]; then
        menu
    fi

    # echo ""
    # done
}

function updatePatron() {
    # clear
    # echo "Update a Patron Details"
    read -r -p "Enter Patron ID: " id
    id=${id^^}

    line=$(grep "^$id:" patron.txt)

    #if line found
    if [[ -n "$line" ]]; then
        IFS=: read -r -r id fname lname phone bdate member jdate <<<"$line"

        clear

        echo "Patron Found!"
        echo "==========================="
        echo "Patron ID: $id"
        echo "First Name: $fname"
        echo "Last Name: $lname"

        while true; do
            read -r -e -i $phone -p "Mobile Number: " newphone
            if [[ $newphone =~ (^01[2-9]-[0-9]{7}$)|(^011-[0-9]{8}$) ]]; then
                clear
                echo "Patron Found!"
                echo "==========================="
                echo "Patron ID: $id"
                echo "First Name: $fname"
                echo "Last Name: $lname"
                echo "Mobile Number: $newphone"
                break
            else
                clear
                echo "Patron Found!"
                echo "==========================="
                echo "Patron ID: $id"
                echo "First Name: $fname"
                echo "Last Name: $lname"
                echo "Invalid Phone Format!"
            fi
        done

        while true; do
            read -r -e -i $bdate -p "Birth Date (DD-MM-YYYY): " newdate
            if [[ $newdate =~ ^(0[1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])-[0-9]{4}$ ]]; then
                clear
                echo "Patron Found!"
                echo "==========================="
                echo "Patron ID: $id"
                echo "First Name: $fname"
                echo "Last Name: $lname"
                echo "Mobile Number: $newphone"
                echo "Birth Date (DD-MM-YYYY): $newdate"
                break
            else
                clear
                echo "Patron Found!"
                echo "==========================="
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

        read -r -n 1 -s -p "Are you sure you want to UPDATE the above Patron Details? (y)es or (q)uit: " choice
        if [[ "${choice,,}" == "y" ]]; then
            sed -i "/^$id:/s/.*/$id:$fname:$lname:$newphone:$newdate:$member:$jdate/" patron.txt
        elif [[ "${choice,,}" == "q" ]]; then
            menu
        fi

    else
        clear
        echo "No Patron with ID $id Found!"
        printf "\nPress (q) to return to Patron Maintenance Menu.\n\n"

        read -r -n 1 -s
    fi

}

function menu() {
    clear
    echo "Patron Maintenance Menu"
    declare -a keys=("A" "S" "U" "D" "L" "P" "J" "Q")
    declare -A choices
    choices["A"]="Add New Patron Details"
    choices["S"]="Search a Patron (by Patron ID)"
    choices["U"]="Update a Patron Details"
    choices["D"]="Delete a Patron Details"
    choices["L"]="Sort Patrons by Last Name"
    choices["P"]="Sort Patrons by Patron ID"
    choices["J"]="Sort Patrons by Joined Date (Newest to Oldest Date)"
    choices["Q"]="Exit from Program"

    for key in "${keys[@]}"; do
        if [ "$key" == "Q" ]; then
            echo -e ""
        fi
        echo "$key - ${choices[$key]}"

    done

    read -r -p "Please select a choice:" key

    key=${key^^}

    if [ "$key" == "A" ]; then #     if [ "$key" == "A" ] || [ "$key" == "a" ];
        printHeader
        addNew

    elif [ "$key" == "S" ]; then
        printHeader
        searchPatron
    elif [ "$key" == "U" ]; then
        printHeader
        updatePatron
    elif [ "$key" == "D" ]; then
        printHeader

    elif [ "$key" == "L" ]; then
        printHeader
    elif [ "$key" == "P" ]; then
        printHeader
    elif [ "$key" == "J" ]; then
        printHeader

    elif [ "$key" == "Q" ]; then
        echo -e "\nGoodbye!"
        exit 0

    else
        echo "Invalid choice: $key"
        waitMessage
        menu

    fi
}

# Display splash screen once on program load
# source splash.sh

# Start program main loop
menu
