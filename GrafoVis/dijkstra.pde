
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
		pq = new PriorityQueue();
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
		if (anim) {
			anim.remove_from_queue(current_point);
		}
		if (current_point < 0) {
			finished = true;
			return -1;
		}
		println("Vertice atual: " + all_points.get(current_point).toString());
		for (int j = 0; j < paths.n; j++) {
			if (this.paths.get(current_point, j) > 0) {
				double new_path = path_length.get(current_point) + this.paths.get(current_point, j);
				if (path_length.get(j) >= 0) {
					if (path_length.get(j) > new_path) {
						path_length.set(j, new_path);
						path.set(j, current_point);
						pq.update(j, new_path);
						println("Vértice Atualizado: " + all_points.get(j).toString());
					}
				} else {
					println("Novo vértice encontrado: " + all_points.get(j).toString());
					path_length.set(j, new_path);
					path.set(j, current_point);
					pq.add(j, path_length.get(j));
					if (anim) {
						anim.add_to_queue(j);
					} 
				}
				if (j == dest) {
					finished = true;
					return current_point;
					println("FIM");
				}
			}
		} 
		return current_point;
	}
	
	public boolean is_finished() {
		return finished;
	}
}