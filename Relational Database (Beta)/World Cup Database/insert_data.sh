#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
  # insert teams' table
    # get team_id from winner
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $TEAM_WINNER_ID ]]
    then
      # insert name
      INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams : $WINNER"
      fi
      # get new team_id from winner
      TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    # get team_id from opponent
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      # insert name
      INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams : $OPPONENT"
      fi
      # get new team_id from opponent
      TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

  # insert games' table
    # get team_id from winner
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $TEAM_WINNER_ID ]]
    then
      echo "Error in finding team_id for winner_id"
    fi
    # get team_id from winner
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      echo "Error in finding team_id for opponent_id"
    fi
    # insert game
    INSERT_STUDENT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_WINNER_ID, $TEAM_OPPONENT_ID, '$WINNER_GOALS', '$OPPONENT_GOALS')")
    if [[ $INSERT_STUDENT_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into games : $ROUND between $WINNER and $OPPONENT played in $YEAR"
        echo "            Results : $WINNER_GOALS - $OPPONENT_GOALS for $WINNER"
      fi
  fi
done
