/**********************************************************************
 *  Randomized Queues and Deques
 **********************************************************************/

Name: Peter Grabowski 
Login: pgrabows@
Precept: P02A
Partner name: Raffi Grinberg
Parner login: rgrinber@ 
Partner precept: P02
Hours to complete assignment: 5 each


/**********************************************************************
 *  Explain briefly how you implemented the randomized queue and deque.
 *  Which data structure did you choose (array, linked list, etc.)
 *  and why?
 **********************************************************************/
For the randomized queue, we used a variable sized array. By using a variable sized away, we were able to return a random item in constant amortized time. If we had used linked lists, it would have taken linear time.

For the deque, we used a doubly-linked list. By using a doubly-linked list, we were easily able to keep track of the first and last items, as well as the second-to-last item (by accessing last’s prev) and add to either side without the need to shift every element.


/**********************************************************************
 *  Briefly describe why any sequence of N randomized queue operations,
 *  starting from an empty randomized queue, takes time proportional
 *  to N.
 **********************************************************************/
Each operation takes constant time c to complete, so the total time taken is cN. All operations take constant time. Dequeue takes constant amortized time, as most operations take a constant number of array accesses. However, when the array is full or ¼ full, it’s necessary to resize the array and copy all the elements into the newly resized array


/**********************************************************************
 *  Briefly describe why each Deque operation takes constant time.
 **********************************************************************/
By using a linked list structure, we avoid having to ever copy items over to a new linked list. Each operation only involves a constant number of node switches, since instead of iterating through the whole list, we can jump to the first item (to insert a new one at the front) or the last item (to insert one at the end) or the second item (to remove one from the front) or the second-to-last item (to remove one from the end).


/**********************************************************************
 *  How much memory (in bytes) does your data type use to store N items.
 *  Use tilde notation to simplify your answer. Use the memory
 *  requirements for a "typical machine" given in Lecture. In your
 *  analysis, do not include the memory for the items themselves
 *  (as this memory is allocated by the client and depends on the item
 *  type) but do include the memory for the references to the items
 *  (in the underlying array or linked list).
 **********************************************************************/

Deque:  Node class:  4 bytes(reference to a generic item) + 4 bytes (reference to a node) + 4 bytes (reference to a node) + 8 bytes (object overhead) = 20 bytes
	  So each deque uses 20 bytes per item in the deque.  Best and worst cases are the same at ~20N.

RandomizedQueue:  Item[T] takes ~4T bytes.  Best case, the array of N elements is full, so the randomizedqueue takes ~4N bytes.  Worst case, the array is ¼-full plus one element (so it hasn’t shrunk yet), so randomizedqueue takes 4*(4*(N-1)) ~ 16N bytes.

               RandomizedQueue             Deque
----------------------------------------------------
best case		~4N					~20N		
worst case		~16N					~20N


/**********************************************************************
 *  Known bugs / limitations.
 **********************************************************************/

None.  Yay!

/**********************************************************************
 *  List whatever help (if any) that you received and from whom,
 *  including help from staff members or lab TAs.
 **********************************************************************/

None.

/**********************************************************************
 *  Describe any serious problems you encountered.                    
 **********************************************************************/

Our original implementation of Deque.java was a singly-linked list, so we had to iterate through the whole list to find the second-to-last item (in order to remove the last one).  Luckily, we caught this problem.

/**********************************************************************
 *  List any other comments here. Feel free to provide any feedback   
 *  on how much you learned from doing the assignment, and whether    
 *  you enjoyed doing it.                                             
 **********************************************************************/

Thanks.
