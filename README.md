battleship
==========
This is a very simple battleship game. The application acts as a server and coordinates game play between two successively joining clients. A client can interact with the server via three API calls:

POST **/games/join**
<pre>
Given the following board(notice how the numbers are used to indicate the length of ship):
  -----------------------------------------
  |   |   |   |   |   |   |   |   |   |   |
  -----------------------------------------
  |   |   |   |   |   |   |   |   |   |   |
  -----------------------------------------
  |   |   |   |   |   |   |   |   |   |   |
  -----------------------------------------
  |   |   |   |   |   |   |   |   |   |   |
  -----------------------------------------
  |   | 5 | 5 | 5 | 5 | 5 |   |   |   |   |
  -----------------------------------------
  |   | 3 | 3 | 3 |   |   | 4 | 4 | 4 | 4 |
  -----------------------------------------
  |   | 2 | 2 |   |   |   |   |   |   | 3 |
  -----------------------------------------
  |   |   |   |   |   |   |   |   |   | 3 |
  -----------------------------------------
  |   |   |   |   |   |   |   |   |   | 3 |
  -----------------------------------------
  |   |   |   |   |   |   |   |   |   |   |
  -----------------------------------------

You would call /games/join with the following parameters:

{ "user" : "JDogg",
  "board" : [["","","","","","","","","",""],
             ["","","","","","","","","",""],
             ["","","","","","","","","",""],
             ["","","","","","","","","",""],
             ["",5,5,5,5,5,"","","",""],
             ["",3,3,3,"","",4,4,4,4],
             ["",2,2,"","","","","","",3],
             ["","","","","","","","","",3],
             ["","","","","","","","","",3],
             ["","","","","","","","","",""]] }

The response should contain the game ID with the following JSON form:
{ "game_id" : 123 }
</pre>
GET  **/games/status**
<pre>
/games/status expects the following parameters:
{ "user" : "JDogg", "game_id" : 123 }

The response should contain the following:
{ "game_status" : "playing" /* or "won", "lost" */, "my_turn" : true /* or false */ }
</pre>
POST **/games/fire**
<pre>
Expects the following parameters:
{ "user" : "JDogg", "game_id" : 123, "shot" : "E9" /* Possible values are in range A1-J10 */ }

The response will tell you if you hit something and whether or not that hit resulted in a sunk ship:
{ "hit" : true, "sunk" : 5 /* number indicating length of ship that was sunk */
</pre>

The flow of a game is simple: client calls join, then proceeds to call status to determine the game status, if game is still active and it is client's turn, a call to fire should be made to fire at opponent's board. Loop until game status is no longer "playing".

The game can be watched as it is being played by the clients. For this reason, it is advisable to put a sleep in the game play loop of the client(0.1 sec is a good starting point). To view the game being played, visit root URL of server in browser, **ex. localhost:3000**, and select game from the drop-down menu. The game will be updated automatically as it is being played.
