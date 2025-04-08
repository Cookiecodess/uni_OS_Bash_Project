
function addNew() {
    continue="y"
    while [[ "$continue" == "y" ]] do
        read -p "Patron ID:" pID
            while [[ -z "$pID" ]]; do
                echo -e "Sorry the Patron ID cannot left blank."
                read -p "Patron ID:" pID
            done
        read -p "First Name:" fname
            while [[ -z "$fname" ]]; do
                echo -e "Sorry the First Name cannot left blank."
                read -p "First Name:" fname
            done
        read -p "Last Name:" lname
            while [[ -z "$lname" ]]; do
                echo -e "Sorry the Last Name cannot left blank."
                read -p "Last Name:" lname
            done
        read -p "Mobile Number(01#-########):" phnum
            while ! [[ "$phnum" =~ ^01[0-9]{1}-[0-9]{7,8}$ ]]; do
                echo -e "Sorry the Phone Number Format is wrong."
                read -p "Mobile Number:" phnum
            done
        read -p "Birth Date (MM-DD-YYYY):" bdate
            while ! [[ "$bdate" =~ ^[0-1][0-9]-[0-3][0-9]-[0-9]{4}$ ]]; do
                echo -e "Sorry the Birth Date Format is wrong."
                read -p "Birth Date (MM-DD-YYYY):" bdate
            done     
        read -p "Membership type (Student / Public):" memberType
            while [[ "$memberType" != "Student" && "$memberType" != "Public" ]]; do

                echo -e "Sorry Please Select (Student/Public)."
                read -p "Membership type (Student / Public):" memberType
            done
        read -p "Joined Date (MM-DD-YYYY):" joinedDate
            while ! [[ "$joinedDate" =~ ^[0-1][0-9]-[0-3][0-9]-[0-9]{4}$ ]]; do
                echo -e "Sorry the Joined Date Format is wrong."
                read -p "Joined Date (MM-DD-YYYY):" joinedDate
            done 

        echo "Press (q) to return to Patron Maintenance Menu."
        read -p "Add another new patron details? (y)es or (q)uit :" continue
            #  if [ "$continue" == "q" ];
            #     then echo "yes"
            # fi
        #echo -e "PatronID:FName:LName:MobileNum:BirthDate:Type:JoinedDate">>patron.txt
        echo -e "$pID:$fname:$lname:$phnum:$bdate:$memberType:$joinedDate">>patron.txt
    done

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
echo -e "\t\t========================"
     if [ "$key" == "A" ];
     #     if [ "$key" == "A" ] || [ "$key" == "a" ];
         then addNew
     fi

