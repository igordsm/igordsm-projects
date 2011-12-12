
class Dijkstra {
	public Graph paths;
	public PriorityQueue pq;
	public ArrayList path_length;
	public ArrayList path;
	public int src, dest;
	public boolean finished;
	public DijkstraAnimation anim = null;		
			
	public Dijkstra(Graph g) {
		this.paths = g;
		path_length = new ArrayList();
		path = new ArrayList();
		pq = new MinHeap(g.n);
		src = 0; dest = 1;
		finished = false;
		
		for (int i = 0; i < this.paths.n; i++) {
			path_length.add(-1);
			path.add(-1);
		}
		path.set(0, 0);
		path_length.set(0, 0);
		pq.add(0, 0);
		println("INICIANDO ALGORITMO DE DIJKSTRA");
	}
	
	public int step() {
		if (finished) return;
		int current_point = pq.min();
		println("PQ MIN" + pq);
		if (anim) {
			anim.remove_from_queue(current_point);
		}
		if (current_point < 0) {
			finished = true;
			return -1;
		}
		println("Vertice atual: " + all_points.get(current_point).toString());
		
		if (current_point == dest) {
			finished = true;
			println("FIM");
			return current_point;
		}
		for (int j = 0; j < paths.n; j++) {
			if (this.paths.get(current_point, j) > 0) {
				double new_path = path_length.get(current_point) + this.paths.get(current_point, j);
				if (path_length.get(j) >= 0) {
					if (path_length.get(j) > new_path) {
						path_length.set(j, new_path);
						path.set(j, current_point);
						pq.update(j, new_path);
						println("Vértice Atualizado: " + all_points.get(j).toString());
						println("PQ MOD" + pq);
					}
				} else {
					println("Novo vértice encontrado: " + all_points.get(j).toString());
					path_length.set(j, new_path);
					path.set(j, current_point);
					pq.add(j, path_length.get(j));
					if (anim) {
						anim.add_to_queue(j);
					} 
					println("PQ ADD" + pq);
				}
			}
		} 
		println("PQ AFTER" + pq);
		return current_point;
	}
	
	public boolean is_finished() {
		return finished;
	}
}

class DijkstraAnimation {
	
	Graph g;
	PriorityQueue pq;
	ArrayList path_length;
	ArrayList visited;
	ArrayList queue;
	Dijkstra dj;
	
	int frame_count = 0;
	int max_frame = 60;
	int last_visited = -1;
	
	public DijkstraAnimation(Graph g, Dijkstra dj) {
		this.g = g;
		this.pq = dj.pq;
		this.path_length = dj.path_length;
		this.visited = new ArrayList();
		this.queue = new ArrayList();
		this.dj = dj;
	}
	
	public boolean changed_vertex() {
		return frame_count == 0;
	}
	
	public void add_visited_vertex(int i) {
		this.visited.add(i);
		last_visited = i;
	}
	
	public void add_to_queue(int i) {
		this.queue.add(i);
	}
	
	public void remove_from_queue(int j) {
		for (int i = 0; i < queue.size(); i++) {
			if (queue.get(i) == j) {
				queue.remove(i);
				break;
			}
		}
	}
	
	
	public void draw() {
		frame_count++;
		if (frame_count == max_frame) {
			frame_count = 0;
		}
		
		if (dj.is_finished()) {
			int orig = 1;
			int dest = dj.path.get(orig);
			stroke(255, 0, 0);
			while (dest != 0 || orig != 0) {
				Point p1 = g.all_points.get(orig);
				Point p2 = g.all_points.get(dest);
				line(p1.x, height-p1.y, p2.x, height-p2.y);
				ellipse(p1.x, height-p1.y, 5, 5);
				ellipse(p2.x, height-p2.y, 5, 5);
				orig = dest;
				dest = dj.path.get(dest);
			} 
		} else {
			this.g.draw();
			// desenha arestas do vértice atual
			fill(255, 0, 0);
			stroke(255, 0, 0);
			if (last_visited >= 0) {
			    Point current_p = g.all_points.get(last_visited);
			    for (int i = 0; i < this.g.n; i++) {
			        if (this.g.get(i, last_visited) > 0) {
			            Point p1 = g.all_points.get(i);
				        line(p1.x, height-p1.y, current_p.x, height-current_p.y);
			        }
			    }
				ellipse(current_p.x, height-current_p.y, 15, 15);
			}
			
			// pinta vertices visitados
			fill(255, 0, 255);
			stroke(255, 0, 255);
			for (int i = 0; i < visited.size(); i++) {
				Point p = g.all_points.get(visited.get(i));
				ellipse(p.x, height-p.y, 5, 5)
			}
			
			
			// pinta vertices na fila
			fill(0, 0, 255);
			stroke(0, 0, 255);
			for (int i = 0; i < queue.size(); i++) {
				Point p = g.all_points.get(queue.get(i));
				ellipse(p.x, height-p.y, 5, 5)
			}
			
			// pinta distâncias atuais para cada vertice
			Font font = loadFont("Arial"); 
			textFont(font); 
			fill(0, 0, 0);
			stroke(0, 0, 0);
			for (int i = 0; i < g.all_points.size(); i++) {
				Point p = g.all_points.get(i);
				int d = Math.round(path_length.get(i));
				String t = d.toString(); 
				text(t, p.x - textWidth(t), height-p.y);
			}
		}
	}
}
