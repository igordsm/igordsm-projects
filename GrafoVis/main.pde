public String mode = "polygon";

Point start = new Point(-1, -1);
Point end = new Point(-1, -1);
ArrayList all_points;
Set sweep_line = null;
Set btree_test;

int current_point = 0;

VisibilityGraphBuildAnimation vgba = null;
DijkstraAnimation dijkstra_anim = null;
Dijkstra dijkstra = null;


void set_mode(String m) {
	mode = m;
}

void clear_state() {
    mode = "polygon";

    start = new Point(-1, -1);
    end = new Point(-1, -1);
    all_points = null;
    sweep_line = null;
    btree_test = null;

    current_point = 0;

    vgba = null;
    dijkstra_anim = null;
    dijkstra = null;
    poly = new Polygon();
    polys = new ArrayList();
}

void init_sweep_line(int point, SortOrder so) {
	sweep_line = new Set();
	Point p1 = all_points.get(point);
	btree_test = new BinaryTree(p1); 
	Edge e = new Edge(p1, new Point(10000, p1.y));
	println("Inicialização da linha de varredura:");
	for (int i = 0; i < all_points.size(); i++) {
   		Edge sweep = all_points.get(so.indexes[i]).next;
   		if (sweep != null && sweep.crosses(e) == true && sweep.p1 != p1 && sweep.p2 != p1) {
   			println("Adicionada aresta: " + sweep.toString());
   			sweep_line.add(sweep);
   			btree_test.add(sweep, e);
   		}
   	}
   	println(btree_test);
   	println("FIM");
}

void update_sweep_line(int point_counter, SortOrder so, Edge current_edge) {
	Point next = current_edge.p2;
	Edge e1, e2;
	e1 = next.prev;
	e2 = next.next;
	if (e1 == null || e2 == null) return;
	Point e1p = e1.p1;
	Point e2p = e2.p2;
	
	println("Atualizando linha de varredura. Linha de varredura: " + current_edge.toString());
	if (e1.p1 != current_edge.p1 && e1.p2 != current_edge.p1) {
		println("Aresta 1 " + e1.toString() + " ; Vértice " + e1p.toString());
		if (current_edge.right(e1p) == true) {
			sweep_line.remove(e1);
			btree_test.remove(e1, current_edge);
			println(btree_test);
		} else {
			sweep_line.add(e1);
			btree_test.add(e1, current_edge);
			println(btree_test);
		}
	}
	if (e2.p1 != current_edge.p1 && e2.p2 != current_edge.p1) {
		println("Aresta 2 " + e2.toString() + " ; Vértice " + e2p.toString());
		if (current_edge.right(e2p) == true) {
			sweep_line.remove(e2);
			btree_test.remove(e2, current_edge);
			println(btree_test);
		} else {
			sweep_line.add(e2);
			btree_test.add(e2, current_edge);
			println(btree_test);
		}
	}
	println("FIM");
}

void check_visibles_vertexes(int point, SortOder so) {
	println("Verificando vértice " + all_points.get(point).toString());
	/* inicializa conjunto com arestas que cruzam com a reta p1 = point */
	init_sweep_line(point, so);
    vgba.start_animation(current_point, so, sweep_line);
}

boolean noCone(Edge current_edge) {
	Point p1 = current_edge.p1;
	Point p2 = current_edge.p2;
	Point prev = p2.prev.p1;
	Point next = p2.next.p2;
	println("Cone: " + prev + "-" + next);
	if (p2.prev.compare(next) >= 0) {
		println("Convexo");
		return current_edge.compare(prev) < 0 && current_edge.compare(next) > 0; 
	} else {
		println("Concavo");
		return !(current_edge.compare(prev) >= 0 && current_edge.compare(next) <= 0);
	}
}

boolean noConeInv(Edge current_edge) {
	Point p1 = current_edge.p1;
	Point p2 = current_edge.p2;
	Point prev = p1.prev.p1;
	Point next = p1.next.p2;
	println("Cone: " + prev + "-" + next);
	if (p1.prev.compare(next) >= 0) {
		println("Convexo");
		return current_edge.compare(prev) > 0 && current_edge.compare(next) < 0; 
	} else {
		println("Concavo");
		return !(current_edge.compare(prev) <= 0 && current_edge.compare(next) >= 0);
	}
}

boolean check_intersections(Edge current_edge) {
	println("Checando interseções de: " + current_edge.toString());
	Point p1 = current_edge.p1;
	Point p2 = current_edge.p2;
	
	if ((p2.polygon != undefined && noCone(current_edge)) || (p1.polygon != undefined && noConeInv(current_edge)) ) {
		println("No cone!");
		return true;
	}
	Edge e = btree_test.getNearestEdge();
	println("Closest: " + e);
	if (e != null) {
 		return current_edge.crosses(e);
	} else {
		return false;
	}
}

void start_algorithm() {
	set_mode("build_graph");
	sweep_line = new Set();
	all_points = get_all_points(polys); 
	all_points.add(0, start);
	all_points.add(1, end);
	
	vgba = new VisibilityGraphBuildAnimation(all_points);
	paths = new Graph(all_points.size(), all_points);
	current_point = 0;
	SortOrder so = sort_around_point(all_points, current_point);
	check_visibles_vertexes(current_point, so);
}

void setup() {
	size(500, 450);
    clear_state();
}

void draw() {
	background(255);
	
	fill(0, 255, 0);
	ellipse(start.x, height-start.y, 5, 5);
	fill(255, 0, 0);
	ellipse(end.x, height-end.y, 5, 5);
	
	
	if (mode == "build_graph") {
		draw_polys(true);
		paths.draw();
		vgba.draw();
		if (vgba.is_finished()) {
			current_point++;
			if (current_point < -1/*all_points.size()*/) {
				SortOrder so = sort_around_point(all_points, current_point);
				check_visibles_vertexes(current_point, so);
			} else {
				/*set_mode("shortest_path");
				dijkstra = new Dijkstra(paths);
				dijkstra_anim = new DijkstraAnimation(paths, dijkstra);
				dijkstra.anim = dijkstra_anim;*/
			}
		}
		if (vgba.changed_edge()) {
			/* olha se cruza com alguem da linha de varredura */
			Edge current = vgba.current_edge();
			boolean intersects = check_intersections(current);
			
			if (intersects == false) {
				paths.add_to_graph(current_point, vgba.so.indexes[vgba.point_counter]);
			}
		} else if (vgba.changed_to_update_sweep_line()) {
			update_sweep_line(vgba.point_counter, vgba.so, vgba.current_edge());
		}
	} else if (mode == "shortest_path") {
		draw_polys(false);
		dijkstra_anim.draw();
		if (dijkstra_anim.changed_vertex() && dijkstra.is_finished() == false) {
			int visited = dijkstra.step();
			if (visited >= 0) { 
				dijkstra_anim.add_visited_vertex(visited);
			}
		} 
	} else {
		draw_polys(true);
	}
}

void mouseClicked() {
	if (mode == "polygon") {
		click_polys(mouseX, mouseY);
	} else if (mode == "start_point") {
		set_start(mouseX, mouseY);
		mode = "polygon";
	} else if (mode == "end_point") {
		set_end(mouseX, mouseY);
		mode = "polygon";
	}
}

void set_start(int x, int y) {
	start.x = x;
	start.y = height-y;
}

void set_end(int x, int y) {
	end.x = x;
	end.y = height-y;
}

Point get_start() {
	return start;
}

Point get_end() {
	return end;
}
