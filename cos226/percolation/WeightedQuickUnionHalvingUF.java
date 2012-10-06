/****************************************************************************
 *  Compilation:  javac WeightedQuickUnionHalvingUF.java
 *  Execution:  java WeightedQuickUnionHalvingUF < input.txt
 *  Dependencies: StdIn.java StdOut.java
 *
 *  Weighted quick-union with path compression via halving.
 *
 ****************************************************************************/

public class WeightedQuickUnionHalvingUF {
    private int[] id;
    private int[] sz;
    private int count;

    // instantiate N isolated components 0 through N-1
    public WeightedQuickUnionHalvingUF(int N) {
        count = N;
        id = new int[N];
        sz = new int[N];
        for (int i = 0; i < N; i++) {
            id[i] = i;
            sz[i] = 1;
        }
    }

    // return number of connected components
    public int count() {
        return count;
    }

    // return root of component corresponding to element p
    private int root(int p) {
        while (p != id[p]) {
            id[p] = id[id[p]];    // path compression by halving
            p = id[p];
        }
        return p;
    }

    // are elements p and q in the same component?
    public boolean find(int p, int q) {
        return root(p) == root(q);
    }

    // merge components containing p and q, making smaller root point to larger one
    public void union(int p, int q) {
        int i = root(p);
        int j = root(q);
        if (i == j) return;
        if   (sz[i] < sz[j]) { id[i] = j; sz[j] += sz[i]; }
        else                 { id[j] = i; sz[i] += sz[j]; }
        count--;
    }


    public static void main(String[] args) {
        int N = StdIn.readInt();
        WeightedQuickUnionHalvingUF uf = new WeightedQuickUnionHalvingUF(N);

        // read in a sequence of pairs of integers (each in the range 0 to N-1),
         // calling find() for each pair: If the members of the pair are not already
        // call union() and print the pair.
        while (!StdIn.isEmpty()) {
            int p = StdIn.readInt();
            int q = StdIn.readInt();
            if (uf.find(p, q)) continue;
            uf.union(p, q);
            StdOut.println(p + " " + q);
        }
        StdOut.println("# components: " + uf.count());
    }

}
