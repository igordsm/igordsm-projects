

PriorityQueue pq;
ArrayList path_length;
ArrayList path;
Graph paths;
int src, dest;
boolean finished;


function init_dijkstra() {
	path_length = new ArrayList();
	path= new ArrayList();
	pq = new PriorityQueue();
	src = 0; dest = 1;
	finished = false;
	ArrayList all_points = paths.all_points;
	for (int i = 0; i < all_points.size(); i++) {
		path_length.add(-1);
		path.add(-1);
	}
	path_length.set(0, 0);
	pq.add(0, 0);
	println("INICIANDO ALGORITMO DE DIJKSTRA");
}

function dijkstra_step() {
	if (finished) return;
	int current_point = pq.min();	
	if (current_point < 0) {
		finished = true;
		return -1;
	}
	println("Vertice atual: " + all_points.get(current_point).toString());
	for (int j = 0; j < paths.n; j++) {
		if (paths.get(current_point, j) > 0) {
			double new_path = path_length.get(current_point) + paths.get(current_point, j);
			if (path_length.get(j) >= 0) {
				if (path_length.get(j) > new_path) {
					path_length.set(j, new_path);
					path.set(j, current_point);
					pq.update(j, new_path);
				}
			} else {
				println("Novo vértice encontrado: " + all_points.get(j).toString());
				path_length.set(j, new_path);
				path.set(j, current_point);
				pq.add(j, path_length.get(j)); 
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