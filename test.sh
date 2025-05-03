#!/bin/bash

# read -p "Whats your name? " var
# echo $var
number=$((1 + 5))
if [ $number -lt 5 ];
    then echo "yes"
elif [ $number -gt 5 ];
    then echo "no"
fi
echo $number

arr=("abc" "vffg")
echo "${arr[@]}" # ${...}

for x in "${arr[@]}"; do
    echo "$x"
    done

# arr = {'a': 'apple', 'b': 'banana'};
# echo arr['a'];
declare -a keys=("A" "B" "C")
declare -A fruits
fruits["A"]="Apple"
fruits["B"]="Banana"
fruits["C"]="Cherry"

for key in "${keys[@]}"; do
    echo "$key - ${fruits[$key]}"
done

function addNum() {
    return $(($1 + $2))
}

function subtract() {
    return $(($1 - $2))
}

addNum 2 6
result1=$?
subtract 6 3
result2=$?
#echo $?
# result=$?
echo $result1
echo $result2

# if []
# comment

str="hello world"
if [ "$str" == "hello world" ]; then
    echo "yes"
else
    echo "no"
fi 