#!/bin/bash
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 =~ ^[0-9]+$ ]]
then
  # search information through atomic_number
  RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) WHERE atomic_number = $1")
elif [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
then
  # search information through symbol
  RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) WHERE symbol = '$1'")
else
  # search information through name
  RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) WHERE name = '$1'")
fi

#if the element not exit 
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  # Set | as the delimiter
  IFS='|'
  echo "$RESULT" | while read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_mass MELTING_POINT BOILING_POINT TYPE_ID
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_mass amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
  # echo "$RESULT" 
fi