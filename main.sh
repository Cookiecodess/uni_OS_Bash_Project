
function addNew() {

    read -p "Patron ID:" pID
    read -p "First Name:" fname
    read -p "Last Name:" lname
    read -p "Mobile Number:" phnum
    read -p "Birth Date (MM-DD-YYYY):" bdate
    read -p "Membership type (Student / Public):" memberType
    read -p "Joined Date (MM-DD-YYYY):" joinedDate
    echo "Press (q) to return to Patron Maintenance Menu."
    read -p "Add another new patron details? (y)es or (q)uit :" chooseAddNew

    echo -e "PatronID:FName:LName:MobileNum:BirthDate:Type:JoinedDate">>patron.txt
    echo -e "$pID:$fname:$lname:$phnum:$bdate:$memberType:$joinedDate">>patron.txt
    
# P1000:Chai Lim:Chin:012-12345678:10-20-1970:Student:01-10-2025
# P1003:Loh Mian:Simon:017-88888888:03-25-2020:Public:02-01-2025
# P1001:Muhamad Abu Bakar:Bin Rashid:014-78945612: 11-29-1990:Student:01-02-2025

}









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
     if [ "$key" == "Q" ];
         then echo -e ""
     fi
    echo "$key - ${choices[$key]}"
    
done

read -p "Please select a choice:" key

echo -e "\t\t ${choices[$key]}!"
echo -e "\t\t========================\n"
     if [ "$key" == "A" ];
         then addNew
     fi

