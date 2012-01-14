class Set {
	/* TODO: melhorar conjunto para poder fazer as operacoes em tempo menor que O(n) */
	private ArrayList edges;
	
	Set() {
		this.edges = new ArrayList();
	}
	
	void add(Edge e) {
		this.edges.add(e);
	}
	
	int size() {
		return edges.size();
	}
	
	Object get(int i) {
		return edges.get(i);
	}
	
	int size() {
		return edges.size();
	}
	
	boolean remove(Edge e) {
		for (int i = 0; i < edges.size(); i++) {
			if (e.equals(edges.get(i)) == true) {
				edges.remove(i);
				return true;
			}
		}
		return false;
	}
	
	String toString() {
		String r = "[";
		for (int i = 0; i < edges.size(); i++) {
			r += edges.get(i).toString() + ", ";
		}
		return r + "]";
	}
}

class PriorityQueue {
	private ArrayList pq;
	private ArrayList priorities;
	
	PriorityQueue() {
		pq = new ArrayList();
		priorities = new ArrayList();
	}
	
	void add(int o, int priority) {
		int i = 0;
		for (; i < pq.size(); i++) {
			if (priorities.get(i) > priority) {
				break;
			}
		}
		pq.add(i, o);
		priorities.add(i, o);
	}
	
	void update(int o, int priority) {
		for (int i = 0; i < pq.size(); i++) {
			if (pq.get(i) == o) {
				priorities.set(i, priority);
			}
		}
	}
	
	int size() {
		return pq.size();
	}
	
	int min() {
		if (pq.size() >= 1) {
			priorities.remove(0);
			return pq.remove(0);
		}
		return -1;
	}
	
	boolean empty() {
		return pq.size() <= 0;
	}
	
	String toString() {
		String r = "[";
		for (int i = 0; i < pq.size(); i++) {
			r += pq.get(i).toString() + ", ";
		}
		return r + "]";
	}

}

class MinHeap extends PriorityQueue {
	int pq[], qp[], cst[];
	int n;
	
	public MinHeap(int N) {
		this.n = 0;
		pq = new int[N+2];
		qp = new int[N+2];
		cst = new int[N+2];
	}

	void add(int o, int priority) {
		n++;
		qp[o] = n;
		pq[n] = o;
		cst[o] = priority;
		fixUp(n);
	}
	
	void update(int o, int priority) {
		cst[o] = priority;
		fixUp(qp[o]);
	}
	
	int min() {
		swap(1, n);
		n--;
		fixDown(1);
		return pq[n+1];
	}
	
	private void swap(int i, int j) {
		int temp = pq[i];
		pq[i] = pq[j];
		pq[j] = temp;
		
		qp[pq[i]] = i;
		qp[pq[j]] = j;
	}
	
	void fixUp(int i) {
		int up = (int) (i/2);
		println("FIXUP" + cst[pq[up]] + " > " + cst[pq[i]]);
		while (i > 1 && cst[pq[up]] > cst[pq[i]] ) {
			println("CST " + cst[pq[up]] + " > " + cst[pq[i]]);
			swap(i, up);
			i = (int) (i/2);
			up = (int) (i/2);
		}
	}
	
	void fixDown(int i) {
		while (2 * i <= n) {
			int c = 2*i;
			if (c <= n -1 && cst[pq[c]] > cst[pq[c+1]]) {
				c++;
			}
			if (cst[pq[i]] <= cst[pq[c]]) {
				break;
			}
			swap(i, c);
			i = c;
		}
	}
	
	int size() {
		return n + 1;
	}
	
	boolean empty() {
		return size() == 0;
	}
	
	String toString() {
		String r = "[";
		for (int i = 1; i <= n; i++) {
			r += "(" + pq[i] + "-" + cst[pq[i]] + "), ";
		}
		return r + "]";
	}
}

class Graph {
	public double[][] graph_points;
	public int n;
	public ArrayList all_points;
	
	Graph(int n_vertices, ArrayList all_points) {
		this.n = n_vertices;
		this.graph_points = new double[n_vertices][n_vertices];
		for (int i = 0; i < this.n; i++) {
			for (int j = 0; j < this.n; j++) {
				this.graph_points[i][j] = -1; // Nao existem distancias negativas, logo nao existe a aresta i->j 
			}
		}
		this.all_points = all_points;
	}
	
	
	public void draw() {
		stroke(255, 255, 0);
		for (int i = 0; i < this.n; i++) {
			for (int j = 0; j < this.n; j++) { 
				if (graph_points[i][j] >= 0) {
					Point ip = all_points.get(i);
					Point jp = all_points.get(j);
					line(ip.x, height-ip.y, jp.x, height-jp.y);
				}
			}	
		}
	}
	
	public double get(int i, int j) {
		return graph_points[i][j];
	}

	public void add_to_graph(int i, int j) {
		Point ip = all_points.get(i);
		Point jp = all_points.get(j);	
		double d = dist(ip.x, ip.y, jp.x, jp.y);
		graph_points[i][j] = graph_points[j][i] = d;
	}	
}
