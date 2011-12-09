class SortOrder {
	public int[] indexes;
	public double[] angles;
	
	public SortOrder(int n) {
		indexes = new int[n];
		angles = new double[n];
		for (int i = 0; i < n; i++) {
			indexes[i] = i;
		}
	}	
}


void merge(SortOrder so, int p, int m, int q) {
    int j = p;
    int k = m;
    int index = new int[q - p + 1];
    println("MERGE " + p + " " + q);
    String s = "";
    for (int i = p; i <= q; i++) {
        if (i == m) s += " | ";
        s += "" + so.angles[so.indexes[i]] + ", ";
    }
    println(s);
    
    for (int i = p; i <= q; i++) {
        if (j >= m) {
            index[i] = so.indexes[k];
            k++;
        } else if (k > q) {
            index[i] = so.indexes[j];
            j++;
        } else {
            if (so.angles[so.indexes[j] ] <= so.angles[so.indexes[k] ] ) {
                index[i] = so.indexes[j];
                j++;
            } else {
                index[i] = so.indexes[k];
                k++;
            }
        }
    }
    for (int i = p; i <= q; i++) {
        so.indexes[i] = index[i];
    }
    s = "";
    for (int i = p; i <= q; i++) {
        s += "" + so.angles[so.indexes[i]] + ", ";
    }
    println(s);
}


void merge_sortR(SortOrder so, int p, int q) {
    println("P " + p.toString() + " Q " + q.toString());
    if (p == q) return;
    if (p == q - 1) {
        if (so.angles[so.indexes[p] ] > so.angles[so.indexes[q] ] ) {
            int temp = so.indexes[p];
		    so.indexes[p] = so.indexes[q];
		    so.indexes[q] = temp;
        }
        return;
    }
    int m = (int) ((p + q)/2);
    merge_sortR(so, p, m);
    merge_sortR(so, m+1, q);
    merge(so, p, m+1, q);
}


SortOrder sort_around_point(ArrayList all_points, int p) {
	int n = all_points.size();
	SortOrder so = new SortOrder(n);
	for (int i = 0; i < n; i++) {
		Point p1, p2;
		p1 = (Point) all_points.get(p);
		p2 = (Point) all_points.get(i);
		so.angles[i] = atan2(p1.y - p2.y, p1.x - p2.x);
	}
	merge_sortR(so, 0, n-1);
	println("SORT FINAL");
	for (int i = 0; i < n; i++) {
	    println(so.angles[so.indexes[i]]);
	}
	return so;
}
