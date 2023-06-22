#!/bin/bash

# Important staff for queries to run
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# IMPORTANT don't use the echo parameter -e with  \n in message prints because tests will not pass!

# Check if there was an arg then do staff, else pop provide arg message
if ! [[ -z $1 ]]
then
  # Check if arg is a number in order to query with the right condition 
  if [[ $1  =~ ^[0-9]+$ ]]
  then
    # Query db
    DATA_RETURN=$($PSQL "SELECT symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")
    # If query returned a null result then pop not found message, else print info 
    if [[ -z $DATA_RETURN ]]
    then
      echo "I could not find that element in the database."
    else
      while IFS=\| read SYMBOL NAME TYPE ATOMIC_M MELTING_P BOILING_P 
      do
        echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_M amu. $NAME has a melting point of $MELTING_P celsius and a boiling point of $BOILING_P celsius."
      done <<<$(echo $DATA_RETURN)
    fi
  # Check if arg is a name in order to query with the right condition
  elif [[ $1  =~ ^[a-zA-Z]*$ ]] && [[ ${#1} -gt 3 ]]
  then
    # Query db
    DATA_RETURN=$($PSQL "SELECT atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1';")
    # If query returned a null result then pop not found message, else print info 
    if [[ -z $DATA_RETURN ]]
    then
      echo "I could not find that element in the database."
    else
      while IFS=\| read ATOMIC_N SYMBOL TYPE ATOMIC_M MELTING_P BOILING_P 
      do
        echo "The element with atomic number $ATOMIC_N is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_M amu. $1 has a melting point of $MELTING_P celsius and a boiling point of $BOILING_P celsius." 
      done <<<$(echo $DATA_RETURN) 
    fi
  # Check if arg is a symbol in order to query with the right condition
  elif [[ $1  =~ ^[a-zA-Z]*$ ]] && [[ ${#1} -le 3 ]]
  then
    # Query db
    DATA_RETURN=$($PSQL "SELECT atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1';")
    # If query returned a null result then pop not found message, else print info 
    if [[ -z $DATA_RETURN ]]
    then
      echo -e "I could not find that element in the database."
    else
      while IFS=\| read ATOMIC_N NAME TYPE ATOMIC_M MELTING_P BOILING_P 
      do
        echo "The element with atomic number $ATOMIC_N is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_M amu. $NAME has a melting point of $MELTING_P celsius and a boiling point of $BOILING_P celsius."
      done <<<$(echo $DATA_RETURN)
    fi
  # if an argument was something else, print the below message
  else
    echo "I could not find that element in the database."
  fi
# Pop provide arg message
else
  echo "Please provide an element as an argument."
fi
