public class State implements Comparable<State> {
    int numMoves; //number of moves it took to reach state
    State prevState; //link to the previous state
    Board currentBoard; //board at current state
    
    
    //constrctor initializes number of moves to zero and previous state to null
    public State(Board board){
        this.currentBoard = board;
        this.numMoves = 0;
        this.prevState = null;
    }
    
    public int compareTo(State that){
        
        //comparing using hamming priority (slower)
        
//        if((this.currentBoard.hamming() + this.numMoves) ==
//           (that.currentBoard.hamming() + that.numMoves))
//            return 0;
//        else if((this.currentBoard.hamming() + this.numMoves) <
//                (that.currentBoard.hamming() + that.numMoves))
//            return -1;
//        else 
//            return 1;
        
        //comparing using manhattan priority (faster)
        
        if((this.currentBoard.manhattan() + this.numMoves) ==
           (that.currentBoard.manhattan() + that.numMoves))
            return 0;
        else if((this.currentBoard.manhattan() + this.numMoves) <
           (that.currentBoard.manhattan() + that.numMoves))
            return -1;
        else 
            return 1;
    }
    
}


