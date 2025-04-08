
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
    if [$key=="Q"];
        then echo "\n"
    fi
    echo "$key - ${choices[$key]}"
    
done

read -p "Please select a choice:" key
echo "Hello, ${choices[$key]}!"

