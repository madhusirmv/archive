/**********************************************************************
 *  Percolation
 **********************************************************************/

Name: Peter Grabowski
Login: pgrabows@
Precept: Fri 11-11:50 P02-B
Operating system: Windows
Compiler: JDK 6.0_23
Text editor / IDE: Dr. Java
Hours to complete assignment (optional): 5


/**********************************************************************
 *  Describe how you implemented Percolation.java. How did you check
 *  whether the system percolates?
 **********************************************************************/
I modeled the NxN grid as a one dimensional Boolean array grid[], with an extra cell at the top and bottom to represent virtual top and bottom rows. If the cell was open, the Boolean value was true. My array had N^2 + 2 elements. The virtual top row was grid[0], the position (1,1) was grid[0], the position (N,N) was grid[N-2], and the virtual top row was grid[N-1]. I wrote a helper function gridIndex(i,j) to convert i,j coordinates to the index of grid[].

I created a quickfind object with N^2 elements. When I opened a cell, I checked if the cells above, below, to the left, and to the right were open. If any of the cells were open, I unioned them with the cell I was currently opening. When drawn, if the cell was in the same quickfind object as the virtual top row, it was considered full. The system percolated when the virtual top row was in the same quickfind object as the virtual bottom row.


/**********************************************************************
 *  Using Percolation with QuickFindUF.java, give a formula (using tilde
 *  notation) for the running time (in seconds) of PercolationStats.java
 *  as a function of N and T. Estimate the largest experiment (T = 1)
 *  you could perform in 1 { minute, day, year } assuming your
 *  computer has enough memory.
 **********************************************************************/

(keep T constant) T=1

 N          time (seconds)
------------------------------
250          3.771
500          59.607
1000         1057.842  




(keep N constant) N=50

 T          time (seconds)
------------------------------
250          1.617
500          3.27
1000         6.42



running time as a function of N and T:  ~ 

N^4 T
~N^4

Largest values of N in given time limit (T = 1)
-----------------------------------------------
1 minute: ~500
1 day: ~3085
1 year: ~13484


/**********************************************************************
 *  Repeat the previous question, but use WeightedQuickUnionUF.java.
 **********************************************************************/

(keep T constant) T=1

 N          time (seconds)
------------------------------
250         0.032
500         0.076
1000        0.328
2000        1.748


(keep N constant) N=50

 T          time (seconds)
------------------------------
250            0.136
500            0.271
1000           0.518
...

running time as a function of N and T:  ~ 

N^2 log(N) T
~N^2



Largest values of N in given time limit (T = 1)
-----------------------------------------------
1 minute: ~21289
1 day:  ~807868
1 year:  ~15434343


/**********************************************************************
 *  How many bytes does your Percolation.java object use as a function
 *  of N? Use tilde notation to simplify your answer.
 **********************************************************************/

using QuickFindUF.java:
~5N^2

using WeightedQuickUnionUF.java:

~9N^2

/**********************************************************************
 *  Known bugs / limitations.
 **********************************************************************/




/**********************************************************************
 *  List whatever help (if any) that you received, including help
 *  from staff members or lab TAs.
 **********************************************************************/
Krithin Sitaram
Jarett Schwartz
Maia Ginsburg

/**********************************************************************
 *  Describe any serious problems you encountered.                    
 **********************************************************************/
I defined my origin at a different point than StdDraw

I had an off by one error with the input I gave Percolation from PercolationStats

I ran into difficulty accounting for the 10% border using SetScale





/**********************************************************************
 *  List any other comments here. Feel free to provide any feedback   
 *  on how much you learned from doing the assignment, and whether    
 *  you enjoyed doing it.                                             
 **********************************************************************/


