class Point {
	public int x, y;
	
	public Edge prev, next;
	
	public Point(int x, int y) {
		this.x = x;
		this.y = y;
		this.prev = null;
		this.next = null;
	}
	
	public String toString() {
		return "(" + x + "," + y + ")";
	}
	
	public boolean equals(Point o) {
		return x == o.x && y == o.y;
	}
}

class Edge {
	/* Aresta de p1 ate p2 */
	public Point p1, p2;
	
	public Edge(Point p1, Point p2) {
		this.p1 = p1;
		this.p2 = p2;
	}
	
	double length() {
		return dist(p1.x, p1.y, p2.x, p2.y);
	}
	
	boolean left(Point p) {
		/*println("ARESTA: " + this);
		if ((p1.x - p.x)*(p2.y - p.y) - (p1.y - p.y)*(p2.x - p.x) >= 0) {
			println("PONTO: " + p + " ESQUERDA");
		} else {
			println("PONTO: " + p + " DIREITA");
		}*/
		return (p1.x - p.x)*(p2.y - p.y) - (p1.y - p.y)*(p2.x - p.x) > 0;
	}
	
	boolean right(Point p) {
		return (p1.x - p.x)*(p2.y - p.y) - (p1.y - p.y)*(p2.x - p.x) < 0
	}
	
	boolean colinear(Point p) {
		return (p1.x - p.x)*(p2.y - p.y) - (p1.y - p.y)*(p2.x - p.x) == 0
	}
	
	boolean crosses(Edge e) {
		boolean t1 = (left(e.p1) && !left(e.p2)) || (left(e.p2) && !left(e.p1));
		boolean t2 = (e.left(p1) && !e.left(p2)) || (e.left(p2) && !e.left(p1));
		return t1 && t2;
	}
	
	public void draw() {
		line(p1.x, p1.y, p2.x, p2.y);
	}
	
	public String toString() {
		return p1.toString() + "->" + p2.toString();
	}
	
	public boolean equals(Edge e) {
		return p1 == e.p1 && p2 == e.p2;
	}
}

class Polygon {
	public ArrayList points;
	boolean complete;
	
	Polygon() {
		this.points = new ArrayList();
		this.complete = false;
	}
	
	void add_point(int x, int y) {
		Point p = new Point(x, y);
		this.points.add(p);
	}
	
	void completed() {
		int n = points.size();
		for (int i = 0; i < n; i++) {
			int next = (i + 1) % n;
			int prev = (i + n - 1) % n;
			Point pnext, pprev;
			pnext = (Point) this.points.get(next);
			pprev = (Point) this.points.get(prev);
			Point p = (Point) this.points.get(i);
			p.prev = new Edge(pprev, p);
			p.next = new Edge(p, pnext);
		}
		this.complete = true;
	}
	
	void draw() {
		if (this.complete) {
			stroke(0,0,0);
		} else {
			stroke(0,0,255);
		}
		int n = this.points.size();
		if (n < 2) return;
		
		Font font = loadFont("Arial"); 
		textFont(font); 
		
		for (int i = 0; i < n; i++) {
			int next = (i + 1) % n;
			Point p1, p2;
			p1 = (Point) this.points.get(i);
			p2 = (Point) this.points.get(next);
			line(p1.x, p1.y, p2.x, p2.y);
			
		}
		fill(0, 0, 255);
		for (int i = 0; i < n; i++) {
			Point p1;
			p1 = (Point) this.points.get(i);
			text(p1.toString(), p1.x, p1.y);			
		}

	}

}

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

class Graph {
	public double[][] graph_points;
	public int n;
	private ArrayList all_points;
	
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
					line(ip.x, ip.y, jp.x, jp.y);
				}
			}	
		}
	}


	public void add_to_graph(int i, int j) {
		Point ip = all_points.get(i);
		Point jp = all_points.get(j);	
		double d = dist(ip.x, ip.y, jp.x, jp.y);
		graph_points[i][j] = d;
	}	
}