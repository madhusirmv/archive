/******************************************************************************
  * Name:  Rafael Grinberg and Peter Grabowski
  * Login:  rgrinber@ and pgrabows@
  * Precept:  P02 and P02A
  *
  * Compilation:  javac Fast.java
  * Dependencies:  Point.java, StdDraw.java, StdIn.java
  *
  * Description:  Use a fast algorithm to examine which subsets of
  * 4 points from a set read from StdIn fall on the same line segment.
  * Print out all the points, and all found line segments
  * (print each line only once).
  * 
  * The algorithm iterates through each point read in lexicographic order,
  * and sorts the remaining points according to the slopes they make with it.
  * If three or more points are collinear with the current point,
  * create a line there if it hasn't been already.
  * 
  * This client assumes that the input is a number of points N,
  * followed by N x- and y-coordinates (separated by spaces),
  * each between 0 and 32767, with no two identical points.
  * 
  *****************************************************************************/

import java.util.Arrays;

public class Fast {
    
    public static void main(String[] args) {
        
        // rescale coordinates and turn on animation mode
        StdDraw.setXscale(0, 32768);
        StdDraw.setYscale(0, 32768);
        StdDraw.show(0);
        
        int N = StdIn.readInt();
        // maintain an array of points from StdIn,
        // to be sorted lexicographically
        Point[] lex = new Point[N];
        // maintain a copy of the lex array,
        // to be sorted by the slopes they make with each point
        Point[] slope = new Point[N];
        
        // read in N points from StdIn
        for (int i = 0; i < N; i++) {
            int x = StdIn.readInt();
            int y = StdIn.readInt();
            Point p = new Point(x, y);
            lex[i] = p;
            slope[i] = p;
        }
        
        // sort the lex array in lexicographic order
        Arrays.sort(lex, 0, N);
        
        // maintain an array which holds collinear points
        Point[] collinear = new Point[N];
        // k keeps track of how many collinear points have been found
        int k;
        // increment keeps track of how much to increment through
        // the slope array
        // (to avoid checking the same lines more than once)
        int increment = 1;
        
        //start watch
        // Stopwatch clock = new Stopwatch();
        // double elapsedTime;
        
        // for each point in the lex array
        for (int i = 0; i < N; i++) {
            
            // draw this point
            lex[i].draw();
            
            // sort the points in the slope array according to
            // the slopes they make with lex[i]
            Arrays.sort(slope, lex[i].BY_SLOPE_ORDER);
            
            // for each point in the slope array
            // (starting from j = 1, because lex[i] = slope[0] since
            //  points that are the same have slope = - infinity)
            for (int j = 1; j < N - 2; j += increment) {
                
                k = 0;
                // by default, j should be incremented by one
                increment = 1;
                
                // check if the next three points in the slope array
                // are colinear with lex[i]
                while ((j + k < N -2)
                           && Point.areCollinear(lex[i], slope[j+k],
                                                 slope[j+k+1], slope[j+k+2])) {
                    // if they are collinear, add the first point
                    // of that set to the collinear array
                    collinear[k] = slope[j+k];
                    // increment the count of how many
                    // collinear points have been found
                    k++;
                }
                
                // if there is a set of at least three points
                // that are collinear with lex[i]
                if (k > 0) {
                    
                    // add the last two points from that set
                    // to the collinear array,
                    // and increment the count of collinear points accordingly
                    collinear[k] = slope[j+k];
                    k++;
                    collinear[k] = slope[j+k];
                    k++;
                    
                    // sort the collinear array lexicographically
                    Arrays.sort(collinear, 0, k);
                    
                    // if this line has not been printed before
                    if (lex[i].compareTo(collinear[0]) < 0) {
                        
                        // print out the number and list of collinear points
                        System.out.print((k+1) + ": ");
                        System.out.print(lex[i].toString());
                        for (int l = 0; l < k; l++) {
                            System.out.print(" -> " + collinear[l].toString());
                        }
                        System.out.println();
                        
                        // draw a single line segment
                        lex[i].drawTo(collinear[k-1]);
                    }
                    
                    // set j to be incremented to the first non-collinear point
                    increment = k;
                }
            }
        }
        
        // elapsedTime = clock.elapsedTime();
        // System.out.println("Elapsed Time = " + elapsedTime);
        
        // display the screen
        StdDraw.show(0);   
    }
    
}