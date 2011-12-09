class SortOrder {
	public int[] indexes;
	public double[] angles;
	public ArrayList all_points;
	Point origin;
	
	public SortOrder(int n, ArrayList all_points, Point origin) {
		indexes = new int[n];
		angles = new double[n];
		for (int i = 0; i < n; i++) {
			indexes[i] = i;
		}
		this.all_points = all_points;
		this.origin = origin;
	}
	
	public int compare(int i, int j) {
	    if (angles[indexes[i]] < angles[indexes[j]]) {
	        return -1;
	    } else if (angles[indexes[i]] > angles[indexes[j]]) {
	        return 1;
	    } else {
	        Point pi = all_points.get(indexes[i]);
	        double di = dist(origin.x, origin.y, pi.x, pi.y);
	        
	        Point pj = all_points.get(indexes[j]);
	        double dj = dist(origin.x, origin.y, pj.x, pj.y);
	        
	        if (di < dj) return -1;
	        else if (di > dj) return 1;
	        return 0;
	    }
	}
}

void merge(SortOrder so, int p, int m, int q) {
    int j = p;
    int k = m;
    int index = new int[q - p + 1];
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
}


void merge_sortR(SortOrder so, int p, int q) {
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
	SortOrder so = new SortOrder(n, all_points, all_points.get(p));
	for (int i = 0; i < n; i++) {
		Point p1, p2;
		p1 = (Point) all_points.get(p);
		p2 = (Point) all_points.get(i);
		so.angles[i] = atan2(p1.y - p2.y, p1.x - p2.x);
	}
	merge_sortR(so, 0, n-1);
	return so;
}
