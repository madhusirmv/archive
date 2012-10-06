/*************************************************************************
  * Names: Peter Grabowski and Rafael Grinberg
  * NetIDs: pgrabows@ and rgrinber@
  * Precepts: P02B and P02
  * 
  * Compilation:  javac Palindrome.java
  * Execution:    java Palindrome
  * Dependencies: Deque.java, StdIn.java
  *
  * A generic deque (a queue from which elements can be added
  * to either the front or back), implemented using a linked list.
  * Each deque element is of type Item.
  *
  *************************************************************************/

public class Palindrome {
    
    private static boolean isComplement(char b1, char b2) {
        
        if (b1 == 'A') {
            if (b2 == 'T')
                return true;
        }
        
        if (b1 == 'T') {
            if (b2 == 'A')
                return true;
        }
        
        if (b1 == 'C') {
            if (b2 == 'G')
                return true;
        }
        
        if (b1 == 'G') {
            if (b2 == 'C')
                return true;
        }
        
        return false;
        
    }
    
    private static boolean compareBases(Deque<Character> bases) {
        
        char b1, b2;
        
        while (!bases.isEmpty()) {
            b1 = bases.removeFirst();
            
            if (bases.isEmpty())
                return false;
            b2 = bases.removeLast();
            if (!isComplement(b1, b2))
                return false;
        }
        
        return true;
    }
    
    public static void main(String[] args) {
        
        char in;
        Deque<Character> bases = new Deque<Character>();
        
        while (!StdIn.isEmpty()) {
            in = StdIn.readChar();
            bases.addLast(in);
        }
    
        System.out.println(compareBases(bases));
    }
    
}