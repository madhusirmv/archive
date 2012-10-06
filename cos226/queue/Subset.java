/*************************************************************************
  * Names: Peter Grabowski and Rafael Grinberg
  * NetIDs: pgrabows@ and rgrinber@
  * Precepts: P02B and P02
  * 
  * Compilation:  javac Subset.java
  * Execution:    java Subset
  * Dependencies: StdIn.java, RandomizedQueue.java
  *
  * A client of RandomizedQueue.java. Reads in strings from StdIn
  * and adds them to a RandomizedQueue. Reads in k from the command line.
  * Returns k items chosen at random without repetition from the 
  * RandomizedQueue
  * 
  *************************************************************************/

public class Subset {
    
    public static void main(String[] args) {
        
        String s;
        int k = Integer.parseInt(args[0]); // read size of subset
        
        RandomizedQueue<String> set = new RandomizedQueue<String>();
        
        while (!StdIn.isEmpty()) {
            s = StdIn.readString();
            set.enqueue(s); // add strings from StdIn to the queue
        }
        
        if (k < 0 || k > set.size())
            throw new RuntimeException("Invalid subset number");
            
        for (int i = 0; i < k; i++)
            // print k strings at random
            System.out.println(set.dequeue());
        
    }
    
}