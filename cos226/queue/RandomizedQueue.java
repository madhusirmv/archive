/*************************************************************************
  * Names: Peter Grabowski and Rafael Grinberg
  * NetIDs: pgrabows@ and rgrinber@
  * Precepts: P02B and P02
  * 
  * Compilation:  javac RandomizedQueue.java
  * Execution:    java RandomizedQueue
  * Dependencies: StdRandom.java
  *
  * A generic randomized queue, implemented using a size-changing array.
  * Each RandomizedQueue element is of type item.
  * Items are added to the queue in order,
  * but returned, removed, and iterated uniformly at random.
  * The array doubles in size whenever full,
  * and contracts in half whenever one-quarter full.
  * 
  * Code skeleton adapted from DoublingQueue.java on Booksite.
  *
  *************************************************************************/

import java.util.Iterator;
import java.util.NoSuchElementException;

public class RandomizedQueue<Item> implements Iterable<Item> {
    private Item[] q;        // queue of Items in an array
    private int N;           // size of the queue

    // construct an empty randomized queue
    public RandomizedQueue() {
        q = (Item[]) new Object[2];
        N = 0;
    }

    // is the queue empty
    public boolean isEmpty() {
        return N == 0;
    }
    
    // return the number of items on the queue
    public int size() {
        return N;
    }

    // resize the array
    private void resize(int max) {
        assert(max >= N);
        Item[] copy = (Item[]) new Object[max];
        for (int i = 0; i < N; i++)
            copy[i] = q[i];
        q = copy;
    }

    // add the item to the queue
    public void enqueue(Item item) {
        // if out of space, double the size of the queue's array
        if (N == q.length) resize(2*q.length);
        q[N] = item;
        N++;
    }

    // delete and return a random item
    public Item dequeue() {
        int i = StdRandom.uniform(N);
        Item temp = q[i];
        q[i] = q[N-1];
        q[N-1] = null;
        N--;
        if (N > 0 && N == q.length/4)
            resize(q.length/2); 
        return temp;
    }
    
    // return (but do not delete) a ranom item
    public Item sample() {
        int i = StdRandom.uniform(N);
        return q[i];
    }

    public Iterator<Item> iterator() { return new QueueIterator(); }

    // return an iterator that returns the items in random order
    private class QueueIterator implements Iterator<Item> {
        private int i = 0;
        public boolean hasNext()  { return i < N;                               }
        public void remove()      { throw new UnsupportedOperationException();  }

        public Item next() {
            if (i == 0)
                StdRandom.shuffle(q);
            if (!hasNext()) throw new NoSuchElementException();
            Item item = q[i];
            i++;
            return item;
        }
    }



    // a main method for testing
    // (adapted from DoublingQueue.java on Booksite)
    public static void main(String[] args) {
        RandomizedQueue<String> test = new RandomizedQueue<String>();
        
        System.out.println("Empty? " + test.isEmpty());
        System.out.println("Size: " + test.size());
        
        test.enqueue("Hello");
        test.enqueue("to");
        test.enqueue("you");
        test.enqueue("and you!");
        
        System.out.println();
        for (String s : test)
            System.out.println(s);
        
        System.out.println();
        System.out.println("Empty? " + test.isEmpty());
        System.out.println("Size: " + test.size());
        System.out.println();

        while (!test.isEmpty())  {
            System.out.println(test.dequeue());
        }
    }


}
