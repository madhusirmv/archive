public class Board {
    
    private int N; //number of rows/columns
    private int[][] grid; //representation of board
    
    public Board(int[][] tiles) {
        // construct a board from an N-by-N array of tiles
        
        N = tiles.length;
        this.grid = new int[N][N];
        
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                
                grid[i][j] = tiles[i][j];
            }
        }
    }
    
    //return the tile that should be at(i, j)
    private int getGoalNum(int i, int j) {
        
        int column = j +1;
        
        if (i == N-1 && j == N-1)
            return 0;
        else
            return (i * N + column);
    }
    
    //return the XC in the goal grid of tile j
    private int getGoalXC(int j) {
        return ((j -1) % N);
    }
    
    //return the YC in the goal grid of tile j
    private int getGoalYC(int i) {
        return ((i -1) / N);
    }
    
    public int hamming() {             
        // number of blocks out of place
        
        int count = 0;
        
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (grid[i][j] != getGoalNum(i, j)) {
                    if (grid[i][j] != 0) {
                        count++;
                    }
                }
            }
        }
        return count;
    }
    
    public int manhattan() {              
        // sum of Manhattan distances between blocks and goal
        int totalDist = 0;
        int yDist;
        int xDist;
        
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                
                //calc manhattan distance of current point
                if (grid[i][j] != getGoalNum(i, j)) {
                    if (grid[i][j] != 0) {
                        xDist = Math.abs(j - getGoalXC(grid[i][j]));
                        yDist = Math.abs(i - getGoalYC(grid[i][j]));
                        totalDist += (xDist + yDist);
                    }
                }
            }
        }
        return totalDist;
    }           
    
    public Board twin() {              
        // a board obtained by exchanging two adjacent blocks in the same row
        int[][] copy = new int[N][N];
        int temp;
        
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                
                copy[i][j] = grid[i][j];
            }
        }
        //if neither of the first two cells in the first row is 
        //zero, switch them
        if (copy[0][0] != 0 && copy[0][1] != 0) {
        temp = copy[0][0];
        copy[0][0] = copy[0][1];
        copy[0][1] = temp;
        }
        
        //if one of the first two cells is zero, switch the first two
        //cells in the second row
        else { 
            temp = copy[1][0];
        copy[1][0] = copy[1][1];
        copy[1][1] = temp;
        }
        
        Board twin = new Board(copy);
        return twin;
}            
    
    public boolean equals(Object y) {              
        // does this board position equal y?
        
        boolean eq = true;
        
        if (y == this) return true;
        if (y == null) return false;
        if (y.getClass() != this.getClass()) return false;
        
        Board that = (Board) y;
        int temp;
        
        //check each element of both boards for equivalence
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                eq &= (this.grid[i][j] == that.grid[i][j]);
            }
        }
        return eq;
        
        
    }    
    
    //swap(i, j) to the left
    private void swapLeft(int array[][], int i, int j) {
        
        assert (j > 0);
        
        int temp = array[i][j];
        array[i][j] = array[i][j - 1];
        array[i][j - 1] = temp;
        
        
    }
    //swap(i, j) to the right
    private void swapRight(int array[][], int i, int j) {
        
        assert (j < N - 1);
        
        int temp = array[i][j];
        array[i][j] = array[i][j + 1];
        array[i][j + 1] = temp;
        
        
    }
    //swap(i, j) up
    private void swapUp(int array[][], int i, int j) {
        
        assert (i > 0);
        
        int temp = array[i][j];
        array[i][j] = array[i - 1][j];
        array[i - 1][j] = temp;
        
        
    }
    //swap(i, j) down
    private void swapDown(int array[][], int i, int j) {
        
        assert (i < N - 1);
        
        int temp = array[i][j];
        array[i][j] = array[i + 1][j];
        array[i + 1][j] = temp;
        
        
    }
    
    //find the x-coordinate of the zero tile
    private int findZeroXC(int array[][]) {
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (array[i][j] == 0)
                    return j;
            }
        }
        return -1;
    }
    //find the y-coordinate of the zero tile
    private int findZeroYC(int array[][]) {
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (array[i][j] == 0)
                    return i;
            }
        }
        return -1;
    }
    
    public Iterable<Board> neighbors() {              
        // all neighboring board positions
        
        int zeroXC = findZeroXC(grid);
        int zeroYC = findZeroYC(grid);
        int[][] gridCopy = new int[N][N];
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                
                gridCopy[i][j] = grid[i][j];
            }
        }
        Stack<Board> stack = new Stack<Board>();
        
        //generate left neighbor
        if (zeroXC > 0) {
            swapLeft(gridCopy, zeroYC, zeroXC);
            Board board1 = new Board(gridCopy);
            stack.push(board1);
            swapLeft(gridCopy, zeroYC, zeroXC);
        }
        
        //generate right neighbor
        if (zeroXC < N - 1) {
            swapRight(gridCopy, zeroYC, zeroXC);
            Board board2 = new Board(gridCopy);
            stack.push(board2);
            swapRight(gridCopy, zeroYC, zeroXC);
        }
        
        //generate up neighbor
        if (zeroYC > 0) {
            swapUp(gridCopy, zeroYC, zeroXC);
            Board board3 = new Board(gridCopy);
            stack.push(board3);
            swapUp(gridCopy, zeroYC, zeroXC);
        }
        
        //generate down neighbor
        if (zeroYC < N - 1) {
            swapDown(gridCopy, zeroYC, zeroXC);
            Board board4 = new Board(gridCopy);
            stack.push(board4);
            swapDown(gridCopy, zeroYC, zeroXC);
        }
        
        return stack;
        
    } 
    public void draw() {              
        // draw the board to standard draw
        String num;
        StdDraw.setXscale(0, N);
        StdDraw.setYscale(0, N);
        
        for (int j = 0; j < N; j++) {
            for (int i = 0; i < N; i++) {
                num = Integer.toString(grid[i][j]);
                StdDraw.text(j, N - i, num);
                
            }
        }
        
        
    }                 
    public String toString() {              
        // string representation of the board in the output for mat specif ied above
        String newline = System.getProperty("line.separator");
        String strRep = Integer.toString(N) + newline;
        
        
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                strRep += String.format("%3d", grid[i][j]);
                if (j == N - 1)
                    strRep += newline;
            }           
        }
        return strRep;
    }
    
    
    public static void main(String[] args) {
    //testing client
        
        // create initial board from standard input
        int N = StdIn.readInt();
        int[][] tiles = new int[N][N];
        for (int i = 0; i < N; i++)
            for (int j = 0; j < N; j++)
            tiles[i][j] = StdIn.readInt();
        
        
        Board board = new Board(tiles);
        
        System.out.println(board.toString());
        System.out.println("Hamming = " + board.hamming());
        System.out.println("Manhattan = " + board.manhattan());
        
        Board twinB = new Board(tiles);
        twinB = board.twin();
        
        System.out.println("Twin = ");
        System.out.println(twinB.toString());
        
        Board copy = new Board(tiles);
        copy = board;
        System.out.println("board = copy? " + board.equals(copy));
        System.out.println("board = twin? " + board.equals(twinB));
        
        System.out.println("Twin Hamming = " + twinB.hamming());
        System.out.println("Twin Manhattan = " + twinB.manhattan());
        
        Stack<Board> test = new Stack<Board>();
        
        //iterate through and put on stack
        for (Board i : twinB.neighbors()) {
            test.push(i);
        }
        Board neighbor = new Board(tiles);
        while (!test.isEmpty()) {
            neighbor = (Board) test.pop();
            System.out.println("Neighbor = ");
            System.out.println(neighbor.toString());
        }
        board.draw();
        //twinB.draw();
        
    }
    
}


