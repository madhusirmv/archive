public class Solver {

    //final states returned from simultaneous A* algorithm on 
    //board and it's twin, respectively. One must be goal state
    private State endState, twinEndState; 
    
    //initial value for if the board is solvable
    private boolean isSolvable = false;
    
    
    
    public Solver(Board initial) {
        // find a solution to the initial board
        
        
        MinPQ<State> pq = new MinPQ<State>(); //min priority queue for board
        
        //min priority queue for board's twin
        MinPQ<State> tpq = new MinPQ<State>(); 
        
        //twin board
        Board twinB = initial.twin();
        
        //current best state for given board, initialized to given board
        State minState = new State(initial);
        
        //current best state for given board's twin,
        //initialized to given board's twin
        State minTwinState = new State(twinB);
        
        //current best board representation of board and it's twin
        Board minBoard, minTwinBoard;
        
        //insert inital states into priority queue
        pq.insert(minState);
        tpq.insert(minTwinState);
        
        //implement A* algorithm, while neither board is the goal state
        while (minState.currentBoard.hamming() > 0 
               && minTwinState.currentBoard.hamming() > 0) { //state !=goal
            
            //set states to the current lowest priority state from respective
            //stack and delete from stack
            minState = pq.delMin();
            minTwinState = tpq.delMin();

            //set current board representation
            minBoard = minState.currentBoard;
            minTwinBoard = minTwinState.currentBoard;
            
            //iterate through all of the current best priority 
            //board's neighbours
            for (Board i : minBoard.neighbors()) {
                //set parameters of the newly generated neighbor's state
                State neighbor = new State(i);
                neighbor.numMoves = minState.numMoves + 1;
                neighbor.prevState = minState;
                
                //if neighbors grandparent is null, or if the current neighbor's 
                //board isn't equal to its grandparent's board, add to the queue
                if ((neighbor.prevState.prevState == null 
   || !neighbor.prevState.prevState.currentBoard.equals(neighbor.currentBoard))
                  ) {
                    pq.insert(neighbor);
                }
            }
            
            //iterate through all of the current best priority 
            //board's twin's neighbours
            for (Board i : minTwinBoard.neighbors()) {
                //set parameters of the newly generated neighbor's state
                State neighbor = new State(i);
                neighbor.numMoves = minState.numMoves + 1;
                neighbor.prevState = minState;
                
                //if neighbors grandparent is null, or if the current neighbor's 
                //board isn't equal to its grandparent's board, add to the queue
                if ((neighbor.prevState.prevState == null 
   || !neighbor.prevState.prevState.currentBoard.equals(neighbor.currentBoard)))
                {
                    tpq.insert(neighbor);
                }
            }
        }
        
        //save the lowest priority element from both queues. 
        //Because above loop broke, one must be the goal state
        endState = minState;
        twinEndState = minTwinState;
        
        //if the given board's priority queue's lowest element is the goal state
        //it's solvable
        if (endState.currentBoard.hamming() == 0 
                && endState.currentBoard.manhattan() == 0)
            isSolvable = true;
        else
            isSolvable = false;
    }
    
    
    
    
    public boolean isSolvable() {
        //checks whether the board is solvable
        return isSolvable;
    }
    
    
    
    public int moves() {
        // return min number of moves to solve initial board; -1 if no solution
        if (!this.isSolvable())
            return -1;
        else       
            return endState.numMoves;
        
    }
    public Iterable<Board> solution() {
        // return sequence of board positions in a shortest solution
        
        State endCopy = endState;
        
        Stack<Board> solution = new Stack<Board>();
        
        while (endCopy.numMoves > 0) {
            solution.push(endCopy.currentBoard);
            endCopy = endCopy.prevState;
        }
        return solution;
    }
    
    
    public static void main(String[] args) {
        // create initial board from standard input
        int N = StdIn.readInt();
        int[][] tiles = new int[N][N];
        for (int i = 0; i < N; i++)
            for (int j = 0; j < N; j++)
            tiles[i][j] = StdIn.readInt();
        Board initial = new Board(tiles);
        
        // solve the puzzle
        Solver solver = new Solver(initial);
        if (!solver.isSolvable()) System.out.println("No solution possible");
        else   
            System.out.println("Minimum number of moves = " + solver.moves());
        
        // print and animate the solution
        StdDraw.show(0);
        for (Board board : solver.solution()) {
            System.out.println(board);
            StdDraw.clear();
            board.draw();
            StdDraw.show(1000);
        }
    }
}