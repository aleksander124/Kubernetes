#!/bin/bash
echo "1. Request CPU"
echo "2. Request memory"
echo "3. Limit CPU"
echo "4. Limit memory"
echo "5. End the script"


main () {
WARTOSC="$9"
kubectl get resourcequotas -A | awk '{print $9}' | grep -o -P '(?<=/).*(?=,)' | awk '{s+=$1} END {printf s}'
}

command () {
echo -n "Choose your value: "
read -p "" VALUE
echo "Chosen value: $VALUE "

if [ "$VALUE" -eq 1 ]
then
kubectl get resourcequotas -A | awk '{print $9}' | grep -o -P '(?<=/).*(?=,)' | awk '{s+=$1} END {printf s}'

elif [ "$VALUE" -eq 2 ]
then
kubectl get resourcequotas -A | awk '{print $13}' | grep -o -P '(?<=/).*(?=,)' | awk '{s+=$1} END {printf s}'

elif [ "$VALUE" -eq 3 ]
then
kubectl get resourcequotas -A | awk '{print $17}' | grep -o -P '(?<=/).*(?=,)' | awk '{s+=$1} END {printf s}'

elif [ "$VALUE" -eq 4 ]
then
kubectl get resourcequotas -A | awk '{print $19}' | grep -o -P '(?<=/).*(?=,)' | awk '{s+=$1} END {printf s}'

elif [ "$VALUE" -eq 5 ]
then
echo "End of script"

fi
}

command


