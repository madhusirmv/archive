/*************************************************************************
  * Name:  Rafael Grinberg and Peter Grabowski
  * Login:  rgrinber@ and pgrabows@
  * Precept:  P02 and P02A
  *
  * Compilation:  javac Brute.java
  * Dependencies:  Point.java, StdDraw.java, StdIn.java
  *
  * Description:  Use a brute-force approach (a nest of 4 loops!)
  * to examine which subsets of 4 points from a set read from StdIn
  * fall on the same line segment.
  * Print out all the points, and all found line segments
  * (including all 4-point fragments of each line).
  * 
  * This client assumes that the input is a number of points N,
  * followed by N x- and y-coordinates (separated by spaces),
  * each between 0 and 32767, with no two identical points.
  * 
  *************************************************************************/

public class Brute {
    
    public static void main(String[] args) {
        
        // rescale coordinates and turn on animation mode
        StdDraw.setXscale(0, 32768);
        StdDraw.setYscale(0, 32768);
        StdDraw.show(0);
        
        int N = StdIn.readInt();
        Point[] points = new Point[N];
        
        // read in N points from StdIn
        for (int i = 0; i < N; i++) {
            int x = StdIn.readInt();
            int y = StdIn.readInt();
            Point p = new Point(x, y);
            points[i] = p;
        }
        
        // start watch
        // Stopwatch clock = new Stopwatch();
        // double elapsedTime;
        
        // iterate through every possible set of 4 points
        for (int i = 0; i < N; i++) {
            // draw each point
            points[i].draw();
            for (int j = 0; j < N; j++) {
                for (int k = 0; k < N; k++) {
                    for (int l = 0; l < N; l++) {
                        
                      
                        // check if 4 points fall on the same line
                        if (Point.areCollinear(points[i], points[j],
                                         points[k], points[l])) {
                            // if they are in order, print out their coordinates
                            // and draw a line segment
                            // (checking that they are in order ensure that
                            //  one line can be drawn at once through all four,
                            //  and that each subsegment of the given points
                            //  is only printed once)
                            if ((points[i].compareTo(points[j]) < 0)
                              && (points[j].compareTo(points[k]) < 0)
                              && (points[k].compareTo(points[l]) < 0)) {
                                System.out.println("4: " + points[i].toString()
                                                       + " -> "
                                                       + points[j].toString()
                                                       + " -> "
                                                       + points[j].toString()
                                                       + " -> "
                                                       + points[k].toString()
                                                       + " -> "
                                                       + points[l].toString());
                                points[i].drawTo(points[l]);
                            }
                        }
                                
                        
                    }
                }
            }
        }
        
        // elapsedTime = clock.elapsedTime();
        // System.out.println("Elapsed Time = " + elapsedTime);
        
        // display the screen
        StdDraw.show(0);
    }
    
}