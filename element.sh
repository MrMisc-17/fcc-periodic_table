#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z "$1" ] 
then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT=$1

if [[ $ELEMENT =~ [^0-9] ]]
then
  # echo NOT_NUM
  INFO=$($PSQL "SELECT e.atomic_number, e.name, symbol, t.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE (e.name = '$ELEMENT' OR e.symbol = '$ELEMENT')")
else
  # echo NUM
  INFO=$($PSQL "SELECT e.atomic_number, e.name, symbol, t.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $ELEMENT")
fi

if [ -z "$INFO" ]
then
  echo "I could not find that element in the database."
  exit 0
fi

echo "$INFO" | while IFS='|' read -r NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
do
  # echo $NUMBER $NAME $SYMBOL $TYPE $MASS $MELTING_POINT $BOILING_POINT
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
