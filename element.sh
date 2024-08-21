#!/bin/bash
#
# This script searches the database for the requested elements,
# and returns the appropriate information found.
#


# check that an arguement is provided
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else


  # Set the database connection as a variable
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  # The element with atomic number 1 is Hydrogen (H). It's a nonmetal, 
  # with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
  # search the databse for the element

  # re='^[0-9]+$'
  # if ! [[ $yournumber =~ $re ]] ; then
  #  echo "error: Not a number" >&2; exit 1
  # fi
  NUMBER_REGEX='^[0-9]+$' 
  if ! [[  $1 =~ $NUMBER_REGEX ]]
  then
    RESULT=$($PSQL "SELECT * FROM elements 
      INNER JOIN properties ON elements.atomic_number = properties.atomic_number 
      INNER JOIN types ON properties.type_id = types.type_id 
      WHERE elements.name = '$1' OR elements.symbol = '$1'")
  else 
    RESULT=$($PSQL "SELECT * FROM elements 
      INNER JOIN properties ON elements.atomic_number = properties.atomic_number 
      INNER JOIN types ON properties.type_id = types.type_id 
      WHERE elements.atomic_number = $1")
  fi


  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME X MASS MELTING_POINT BOILING_POINT X X TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi



fi
