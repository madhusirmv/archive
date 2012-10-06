/*************************************************************************
  * Name:  Rafael Grinberg and Peter Grabowski
  * Login:  rgrinber@ and pgrabows@
  * Precept:  P02 and P02A
  *
  * Compilation:  javac Point.java
  * Dependenices:  StdIn.java (main only)
  *
  * Description:  An immutable data type for points in the plane.
  * Code adapted from given skeleton.
  *
  *************************************************************************/

import java.util.Comparator;
import java.util.Arrays;

public class Point implements Comparable<Point> {
    
    // comparator to compare other points by the slope they make
    // with this point
    public final Comparator<Point> BY_SLOPE_ORDER = new BySlopeComparator();
    // x coordinate
    private final int x;
    // y coordinate
    private final int y;
    
    // constructor
    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    // define comparator class
    private class BySlopeComparator implements Comparator<Point> {
        
        // return a negative number if the slope p makes with this
        // is less than the slope q makes with this
        public int compare(Point p, Point q) {
            
            int pdy = y - p.y;
            int pdx = x - p.x;
            int qdy = y - q.y;
            int qdx = x - q.x;
            
            // we assume p != q
            
            // if p = this, they are the same point,
            // so p has slope = negative infinity
           if ((x == p.x) && (y == p.y))
               return -1;
           // if q = this, they are the same point,
           // so q has slope = negative infinity
           if ((x == q.x) && (y == q.y))
               return 1;
           
           // if p has infinite slope
           if (pdx == 0) {
               // if q also has infinite slope
               if (qdx == 0)
                   return 0;
               else
                   return 1;
           }
           // if q has infinite slope (and p doesn't)
           if (qdx == 0)
               return -1;
            
           // if one (and only one) of the denominators
           // of the slope comparison equation is negativve,
           // reverse the sign of the comparison
           if (((pdx < 0) || (qdx < 0)) && !((pdx < 0) && (qdx < 0)))
               return (qdy*pdx) - (pdy*qdx);
            else
                return (pdy*qdx) - (qdy*pdx);
        }
    }
    
    // are the 3 points p, q, and r collinear?
    public static boolean areCollinear(Point p, Point q, Point r) {
        return (q.y - p.y)*(q.x - r.x) == (q.y - r.y)*(q.x - p.x);
    }
    
    // are the 4 points p, q, r, and s collinear?
    public static boolean areCollinear(Point p, Point q, Point r, Point s) {
        return ((q.y - p.y)*(q.x - r.x) == (q.y - r.y)*(q.x - p.x))
            && ((q.y - p.y)*(q.x - s.x) == (q.y - s.y)*(q.x - p.x));
    }
    
    // plot this point using StdDraw
    public void draw() {
        StdDraw.point(x, y);
    }
    
    // draw line from this point to that point using standard draw
    public void drawTo(Point that) {
        StdDraw.line(this.x, this.y, that.x, that.y);
    }
    
    // is this point lexicographically smaller than that one?
    public int compareTo(Point that) {
        if (this.y == that.y)
            return (this.x - that.x);
        else
            return (this.y - that.y);
    }
    
    // return string representation of this point
    public String toString() {
        return "(" + x + ", " + y + ")";
    }
    
    // test the methods of the Point class
    // (except the draw methods, which are tested in PointPlotter.java)
    public static void main(String[] args) {
        
        int N = 4;
        int x, y;
        Point[] points = new Point[N];
        System.out.println("Input 4 points:");
        
        for (int i = 0; i < N; i++) {
            System.out.print("x = ");
            x = StdIn.readInt();
            System.out.print("y = ");
            y = StdIn.readInt();
            Point p = new Point(x, y);
            points[i] = p;
        }
        
        System.out.println("You inputted:");
        for (int i = 0; i < N; i++) {
            System.out.println(i + ": " + points[i].toString());
        }
        System.out.println();
        
        System.out.println("Are the first 3 points collinear? "
                               + areCollinear(points[0], points[1], points[2]));
        System.out.println("Are all 4 points collinear? "
                               + areCollinear(points[0], points[1],
                                              points[2], points[3]));
        System.out.println();
        
        // sort the array points according to the slopes they make
        // with the first points
        Arrays.sort(points, points[0].BY_SLOPE_ORDER);
        // print out the points in the new order
        System.out.println("Sorted by slope order with the first point:");
        for (int i = 0; i < N; i++) {
            System.out.println(i + ": " + points[i].toString());
        }
    }
}
