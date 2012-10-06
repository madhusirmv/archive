/**********************************************************************
 *  Pattern Recognition readme.txt
 **********************************************************************/


Name: Rafael Grinberg             
Login: rgrinber@            
Precept: P02  
Partner name: Peter Grabowski     
Partner login: pgrabows@
Partner precept: P02A
Hours to complete assignment (optional): 8 hours (each)


/**********************************************************************
 *  Step 1.  Explain briefly how you implemented brute force.
 *           Describe how you implemented comparison and the areCollinear
 *           methods in the Point data type.
 **********************************************************************/


We implemented Brute force using a quadruple nested for loops. We 
examined every possible set of 4-tuples, including all permutations. 
We only printed the line, however, if the points were in lexicographic 
order, meaning it wasn't a segment we had already seen. We printed out
every 4-point sub segment as well.

We checked if the slope of point q with point p was equivalent to the
slope of point r with point p, and also equivalent to the slope of
point s with point p


/**********************************************************************
 *  Step 2.  Explain briefly how you implemented the sorting solution.
 *           Did you sort by angle, slope, or something else?
 *           What steps did you do to print a minimal representation?
 **********************************************************************/


We maintained two arrays (called lex and slope.) One array (lex) was 
sorted lexicographically and acted as the index. We traversed through
lex one point at a time, which ensured we examined no point more than
once. 

The second array (slope) was resorted with respect to the slope each 
each point in slope made with lex[i] each time we stepped through
lex. 

We then stepped through the slope array in search of points that made
the same slope with lex[i]. If we found a set of three or more points,
we added them to a third array (collinear) and sorted it 
lexicographically. We then checked to ensure the lexicographic index
of each point in collinear was greater than lex[i], ensuring that this
was not a line we had seen before. 


/**********************************************************************
 *  Empirical    Fill in the table below with actual running times in
 *  Analysis     seconds when reasonable (say 180 seconds or less).
 *               You can round to the nearest tenth of a second.
 **********************************************************************/


      N       brute       sorting
---------------------------------
     10        0.03         0.00
     20        0.08         0.03
     40        0.13         0.03
     80        1.39         0.09
    100        3.64         0.13
    150       15.34         0.06
    200       48.24         0.09
    400	    >180.00         0.16
   1000  a long time        0.61
   2000  a very long time   2.72
   4000  see you next year 11.62
   8000  forever           50.72
  10000  forever++         80.31


/**********************************************************************
 *  Estimate how long it would take to solve an instance of size
 *  N = 1,000,000 for each of the two algorithms using your computer.
 **********************************************************************/


Brute: (3.05e-8)(N^4)= 3.05e16 seconds = 967 billion years

Sorting: (2.03e-7)((N^2)log(N)) = 1.2e6 seconds = 14.1 days


/**********************************************************************
 *  Theoretical   Give the worst-case running time of your programs
 *  Analysis      as a function of N. Justify your answer briefly.
 **********************************************************************/


Brute: N^4

For Brute.java, every case is the worst case,
and it takes quartic time


Sorting: Nlog(N) + (N)Nlog(N) + (N^2)Nlog(N)
         ~ (N^3)log(N)

For Fast.java, the worst case is if all points are on a grid,
since then the array collinear will include every point
(for each iteration of i and j), so the collinear array will be sorted
N^2 times.  We assume Arrays.sort uses QuickSort (which takes NlogN).


/**********************************************************************
 *  Known bugs / limitations. For example, if your program prints
 *  out different representations of the same line segment when there
 *  are 5 or more points on a line segment, indicate that here.
 **********************************************************************/


None.


/**********************************************************************
 *  List whatever help (if any) that you received. Be specific with
 *  the names of lab TAs, classmates, or course staff members.
 **********************************************************************/


None.


/**********************************************************************
 *  Describe any serious problems you encountered.                    
 **********************************************************************/


We forgot to check if every set of three points was collinear with 
lex[i].

We also ran into some difficulty checking for infinite/negative 
infinite cases in the slope comparator in Point.java.


/**********************************************************************
 *  List any other comments here. Feel free to provide any feedback   
 *  on how much you learned from doing the assignment, and whether    
 *  you enjoyed doing it.                                             
 **********************************************************************/

Thanks!

