
ArrayList polys = new ArrayList();
Polygon poly = new Polygon();

void draw_polys(boolean draw_points) {
	for (int i = 0; i < polys.size(); i++) {
		Polygon p = (Polygon) polys.get(i);
		p.draw(draw_points);
	}
	poly.draw();
}

void click_polys(int x, int y) {

	poly.add_point(x, height-y);
}

void finish_poly() {
	poly.completed();
	polys.add(poly);
	poly = new Polygon();
	
}

ArrayList get_all_points(ArrayList polys) {
	ArrayList all = new ArrayList();
	for (int i = 0; i < polys.size(); i++) {
		Polygon p = (Polygon) polys.get(i);
		all.addAll(p.points);	
	}
	return all;
}

ArrayList get_polys() {
	return polys;
}

class Point {
	public float x, y;
	public Polygon polygon;	
	public Edge prev, next;
	
	public Point(float x, float y) {
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
	
	float edge_length() {
		return dist(p1.x, p1.y, p2.x, p2.y);
	}
	
	boolean left(Point p) {
		return compare(p) > 0;
	}
	
	boolean right(Point p) {
		return compare(p) < 0;
	}
	
	boolean colinear(Point p) {
		return compare(p) == 0;
	}
	
	float compare(Point p) {
		return (p2.x - p1.x)*(p.y - p1.y) - (p2.y - p1.y)*(p.x - p1.x);
	}
	
	boolean crosses(Edge e) {
	    if (colinear(e.p1) || colinear(e.p2)) return false;
		boolean t1 = (left(e.p1) && !left(e.p2)) || (left(e.p2) && !left(e.p1));
		boolean t2 = (e.left(p1) && !e.left(p2)) || (e.left(p2) && !e.left(p1));
		return t1 && t2;
	}
	
	public void draw() {
		line(p1.x, height-p1.y, p2.x, height-p2.y);
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
			p.polygon = this;
			p.prev = new Edge(pprev, p);
			p.next = new Edge(p, pnext);
		}
		this.complete = true;
	}
	
	void draw(boolean draw_points) {
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
			line(p1.x, height-p1.y, p2.x, height-p2.y);
			
		}
		if (draw_points) {
			fill(0, 0, 255);
			for (int i = 0; i < n; i++) {
				Point p1;
				p1 = (Point) this.points.get(i);
				text(p1.toString(), p1.x, height-p1.y);			
			}
		}
	}

}
