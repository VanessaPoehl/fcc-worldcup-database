#! /bin/bash

# Variable PSQL: speichert den Basisbefehl für alle Abfragen
# -t (--tuples-only) = nur Datenzeilen, keine Spaltenüberschriften/Trennlinien
# --no-align = keine hübsche Tabellenformatierung (reiner Text)
PSQL="psql --username=postgres --dbname=worldcup -t --no-align -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
# Aggregatfunktion SUM(): summiert eine Spalte über alle Zeilen auf
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
# SUM() über einen berechneten Ausdruck (winner_goals + opponent_goals), Addition findet pro Zeile statt, dann wird summiert
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
# Aggregatfunktion AVG(): berechnet den Durchschnitt einer Spalte
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
# ROUND(x, 2): rundet den Rückgabewert von AVG() auf 2 Nachkommastellen
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
# AVG() über einen berechneten Ausdruck (Summe beider Teams pro Spiel), analog zu SUM() oben
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
# Aggregatfunktion MAX(): liefert den größten vorkommenden Wert einer Spalte
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
# COUNT(*): zählt Zeilen; WHERE filtert vorher auf Zeilen mit winner_goals > 2
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
# INNER JOIN: verknüpft games und teams über die ID (nur Zeilen mit Treffer in beiden Tabellen)
# WHERE mit AND: kombiniert zwei Filterbedingungen (Jahr UND Runde)
echo "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id = teams.team_id WHERE year = 2018 AND round = 'Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
# Zwei INNER JOIN-Abfragen (einmal über winner_id, einmal über opponent_id)
# UNION: kombiniert die Ergebnisse beider SELECTs zu einer Liste und entfernt dabei automatisch Duplikate
# ORDER BY: sortiert das Gesamtergebnis alphabetisch (aufsteigend = Standard)
echo "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id = teams.team_id WHERE year = 2014 AND round = 'Eighth-Final' UNION SELECT name FROM games INNER JOIN teams ON games.opponent_id = teams.team_id WHERE year = 2014 AND round = 'Eighth-Final' ORDER BY name")"

echo -e "\nList of unique winning team names in the whole data set:"
# DISTINCT: entfernt doppelte Werte aus dem Ergebnis (jedes Team nur einmal, auch wenn es mehrfach gewonnen hat)
# INNER JOIN + ORDER BY wie oben
echo "$($PSQL "SELECT DISTINCT name FROM games INNER JOIN teams ON games.winner_id = teams.team_id ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
# INNER JOIN wie oben; WHERE filtert nur Finalspiele; ORDER BY sortiert chronologisch nach Jahr
echo "$($PSQL "SELECT year, name FROM games INNER JOIN teams ON games.winner_id = teams.team_id WHERE round = 'Final' ORDER BY year")"

echo -e "\nList of teams that start with 'Co':"
# LIKE mit Platzhalter: 'Co%' bedeutet "beginnt mit Co, danach beliebig viele Zeichen"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
