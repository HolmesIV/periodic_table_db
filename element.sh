if [[ $# -eq 0 ]] ; then
    echo "Please provide an element as an argument."
    exit 0
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $1 =~ ^[0-9]+$ ]]
then
    # Get element by atomic number
    RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id)
      WHERE atomic_number = $1;")
  
    # if not found
    if [[ -z $RESULT ]]
    then
        echo "I could not find that element in the database."
        exit 0
    fi
    echo "$RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
    do
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done 

fi

if [[ $1 =~ ^[a-zA-Z]+$ ]]
then
    # Get element by symbol
    RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id)
     WHERE symbol = '$1';")
  
    # if not found by symbol, check by name
    if [[ -z $RESULT ]]
    then
        RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id)
        WHERE name = '$1';")
    fi
    
    # Didn't find element, tell user element not found
    if [[ -z $RESULT ]]
    then
        echo "I could not find that element in the database."
        exit 0
    fi

    echo "$RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
    do
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done 
fi
