PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+ ]]
  then
    ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  fi
  if [[ -z $ID ]]
  then
    ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  fi
  if [[ -z $ID ]]
  then
    ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  fi

  if [[ -z $ID ]]
  then
    echo "I could not find that element in the database."
  else
    ID=$(echo "$ID" | xargs)
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ID")
    NAME=$(echo "$NAME" | xargs)
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ID")
    SYMBOL=$(echo "$SYMBOL" | xargs)

    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ID")

    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    TYPE=$(echo "$TYPE" | xargs)

    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ID")
    ATOMIC_MASS=$(echo "$ATOMIC_MASS" | xargs)

    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ID")
    MELTING_POINT=$(echo "$MELTING_POINT" | xargs)

    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ID")
    BOILING_POINT=$(echo "$BOILING_POINT" | xargs)

    echo "The element with atomic number $ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    # is $NAME($SYMBOL)"
  fi
  
fi