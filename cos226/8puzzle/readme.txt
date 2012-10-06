/**********************************************************************
 *  8-Puzzle readme.txt template
 **********************************************************************/

Name: Peter Grabowski
Login: pgrabows
Precept: P02A

/**********************************************************************
 *  Explain briefly how you implemented Board.java.
 **********************************************************************/

I implemented Board.java as an NxN two dimensional array. Each spot
in the array represented a tile




/**********************************************************************
 *  Explain briefly how you represented states in the game
 *   (board + number of moves + previous state).
 **********************************************************************/

I represented each potential state of the board in a separate class
State. Each State stored the number of moves it took to get to that 
state, a link to the previous state , and the current board. 





/**********************************************************************
 *  Explain briefly how you detected unsolvable puzzles.
 **********************************************************************/
In the constructor of each solver, I solved both the given initial
board and its twin simultaneously. If either matched the goal state, 
it caused the loop to break. At that point, if it was the twin board
that led to the goal state, I knew that the original board was 
unsolvable.







/**********************************************************************
 *  For each of the following instances, give the minimal number of 
 *  moves to reach the goal state. Also give the amount of time
 *  it takes the A* heuristic with the Hamming and Manhattan
 *  priority functions to find the solution. If it can't find the
 *  solution in a reasonable amount of time (say, 5 minutes) indicate
 *  that instead.
 **********************************************************************/

                  number of          seconds
     instance       moves      Hamming     Manhattan
   ------------  ----------   ----------   ----------
   puzzle28.txt     28          12.048         0.173
   puzzle30.txt     30          24.402         0.441
   puzzle32.txt     32         (unsolvable)    9.269
   puzzle34.txt     34         (unsolvable)     1.74
   puzzle36.txt     36         (unsolvable)    41.4
   puzzle38.txt     38         (unsolvable)    68.656
   puzzle40.txt     40         (unsolvable)     9.001
   puzzle42.txt     42         (unsolvable)   170.088



/**********************************************************************
 *  If you wanted to solve random 4-by-4 or 5-by-5 puzzles, which
 *  would you prefer:  more time (say, 10x as much), more memory
 *  (say 10x as much), or a better priority function? Why?
 **********************************************************************/
I'd prefer a better priority function. Manhattan is superior to 
Hamming, and runs significantly faster. A better priority function
will lead to better choices being made about which neighbor to use,
decreasing the number of neighbors checked and therefore the amount
of memory used





/**********************************************************************
 *  Known bugs / limitations.
 **********************************************************************/
I can't solve above puzzle 31 while using the hamming priority function

I received the following checkstyle audit

Board.java:111:5: Definition of 'equals()' 
without corresponding definition of 'hashCode()'.
Board.java:135:38: Array brackets at illegal position.
Board.java:146:39: Array brackets at illegal position.
Board.java:157:36: Array brackets at illegal position.
Board.java:168:38: Array brackets at illegal position.
Board.java:180:39: Array brackets at illegal position.
Board.java:190:39: Array brackets at illegal position.
Audit done.

I was not sure what to do with either error. If I changed my array 
brackets, I received a compile time error. 

Additionally, I implemented equals() exactly as I found it in 
Person.java

/**********************************************************************
 *  List whatever help (if any) that you received. Be specific with
 *  the names of lab TAs, classmates, or course staff members.
 **********************************************************************/
Kay Ousterhout
Lavanya Jose
Mike Adelson





/**********************************************************************
 *  Describe any serious problems you encountered.                    
 **********************************************************************/



/**********************************************************************
 *  If you worked with a partner, assert below that you followed
 *  the protocol as described on the assignment page. Give one
 *  sentence explaining what each you contributed.
 **********************************************************************/







/**********************************************************************
 *  List any other comments here. Feel free to provide any feedback   
 *  on how much you learned from doing the assignment, and whether    
 *  you enjoyed doing it.                                             
 **********************************************************************/