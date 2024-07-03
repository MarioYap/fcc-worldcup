#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    if [[ -z $TEAM_ID ]]
    then
      CONFIRM_WINNER=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $CONFIRM_WINNER == "INSERT 0 1" ]]
      then
        echo $WINNER
      fi
    fi
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_ID ]]
    then
      CONFIRM_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $CONFIRM_OPPONENT == "INSERT 0 1" ]]
      then
        echo $OPPONENT
      fi
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    CONFIRM_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done

