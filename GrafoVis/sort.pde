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

SortOrder sort_around_point(ArrayList all_points, int p) {
	/* TODO: MUDAR SORT PARA N LOG N */
	int n = all_points.size();
	SortOrder so = new SortOrder(n);
	for (int i = 0; i < n; i++) {
		Point p1, p2;
		p1 = (Point) all_points.get(p);
		p2 = (Point) all_points.get(i);
		so.angles[i] = atan2(p1.y - p2.y, p1.x - p2.x);
	}
	for (int i = 0; i < n; i++) {
		int mini = i;
		for (int j = i+1; j < n; j++) {
			if (so.angles[so.indexes[j]] < so.angles[so.indexes[mini]]) {
				mini = j;
			}
		}
		/* exchange angles */
		int temp = so.indexes[i];
		so.indexes[i] = so.indexes[mini];
		so.indexes[mini] = temp;
	}
	return so;
}