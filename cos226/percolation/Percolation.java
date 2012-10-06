/****************************************************************************
  *  Compilation:  javac Percolation.java
  *  Dependencies: StdIn.java StdOut.java WeightedQuickUnionUF.java
  *
  *  Models an N*N grid of cells. Cells are either open or closed. Determines
  *  if grid percolates using a WeightedQuickUnionUF object
  ****************************************************************************/

public class Percolation {
    
    private int num; //number of columns/rows
    private int virtRows = 2; //account for virtual top and bottom rows
    private int numCells; //total number of cells, including virt top/bottom
    private boolean[] grid; //each cell corresponds to an array index
    private WeightedQuickUnionUF uf; //quickfind object to track connections 
    
    public Percolation(int N) { // create N-by-N grid, with all sites blocked
        
        numCells = (N*N) + virtRows; //total number of cells       
        grid = new boolean[numCells]; 
        num = N;
        
        //initalize all cells to closed(false)
        for (int i = 0; i < numCells; i++) {
            grid[i] = false;  
        }
        grid[0] = true; //initialize virtual top row to full
        grid[numCells - 1] = true; //initialize virtual bottom row to open
        uf = new WeightedQuickUnionUF(numCells);
    }
    
    //returns whether given row,column defind a cell in the grid by comparing 
    //against boundaries of grid
    private boolean inGrid(int row, int column) {
        if ((row > num) || (column > num) || (row < 0) || (column < 0)) {
            
            
            StdOut.println("i= " + row);
            StdOut.println("j= " + column);
            throw new RuntimeException("Value entered is not within grid");
            
        }
        else {
            return true; }
    }
    
    //maps 2-D coordinates (row,column)onto 1-D line
    private int gridIndex(int row , int column) {
        
        //subtract one from column to shift index (no row 0 on grid)
        int position = ((row - 1) * num) + column; 
        return position;
    }
    
    //returns 1-D array index of the cell above (row,column)
    private int checkUp(int row , int column) {
        int cellUp = gridIndex(row , column) - num;
        
        //accounts for top edge
        if (cellUp < 0)
            cellUp = 0;
        return cellUp;
    }
    
    //returns 1-D array index of the cell below (row,column)
    private int checkDown(int row , int column) {
        int cellDown = gridIndex(row , column) + num;
        
        //accounts for bottom edge
        if (cellDown > numCells - 1)
            cellDown = numCells - 1;
        return cellDown;
    }
    
    //returns 1-D array index of the cell right of (row,column)
    private int checkRight(int row , int column) {
        int cellRight = gridIndex(row , column) + 1;
        
        //accounts for right edge. if edge, returns itself
        if (column == num)
            return gridIndex(row , column);
        return cellRight;
    }
    
    //returns 1-D array index of the cell left of (row,column)
    private int checkLeft(int row, int column) {
        int cellLeft = gridIndex(row , column) - 1;
        
        //accounts for right edge. if edge, returns itself
        if (column == 1)
            return gridIndex(row, column);
        return cellLeft;
    }
    
    // open site (row i, col j) if it is not already
    public void open(int i, int j) {         
//check if in grid
        if (!inGrid(i, j))
            return;
        int cell = gridIndex(i, j);
        
        //check if already open
        if (grid[cell])
            return;
        
        //check surrounding cells. 
        int cUp = checkUp(i, j);
        int cDown = checkDown(i, j);
        int cLeft = checkLeft(i, j);
        int cRight = checkRight(i, j);
        
        grid[cell] = true;
        
        //if adjacent cell is open, union with open cell
        if (grid[cell] == grid[cUp])
            uf.union(cell, cUp);
        if (grid[cell] == grid[cDown])
            uf.union(cell, cDown);
        if ((grid[cell] == grid[cLeft]) && (cell != cLeft))
            uf.union(cell, cLeft);
        if ((grid[cell] == grid[cRight]) && (cell != cRight))
            uf.union(cell, cRight);
        return;
    }
    
    // is site (row i, col j) open?
    public boolean isOpen(int i, int j) {    
        if (!inGrid(i, j))
            return false;
        
        
        return (grid[gridIndex(i, j)]);
    }
    
    // is site (row i, col j) full?
    public boolean isFull(int i, int j) {    
        if (!inGrid(i, j))
            return false;
        return uf.find(0, gridIndex(i, j));
    }
    // does the system percolate?
    public boolean percolates() {            
        return uf.find(0, numCells-1);
    }
    
}