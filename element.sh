#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # request provided argument from database
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$1;")
  else
    ATOMIC_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING (type_id) WHERE name='$1' OR symbol='$1';")
  fi
  # if not result
  if [[ -z $ATOMIC_RESULT ]]
  then
    # echo error message
    echo "I could not find that element in the database."
  else
    # echo $ATOMIC_RESULT | IFS='|' read -r NUMBER SYMBOL NAME MASS MELTING BOILING TYPE;

    # echo $NUMBER $SYMBOL
    IFS='|' read -r id symbol name atomic_mass melting_point boiling_point type <<< "$ATOMIC_RESULT"

    # Print the values of the variables
    echo "The element with atomic number $id is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  fi




fi
