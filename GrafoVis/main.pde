public String mode = "polygon";

Point start = new Point(-1, -1);
Point end = new Point(-1, -1);
ArrayList all_points;
Set sweep_line = null;

int current_point = 0;
VisibilityGraphBuildAnimation vgba = null;

void set_mode(String m) {
	mode = m;
}

void init_sweep_line(int point, SortOrder so) {
	sweep_line = new Set();
	Point p1 = all_points.get(point); 
	Edge e = new Edge(p1, new Point(100000000, p1.y));
	println("Inicialização da linha de varredura:");
	for (int i = 0; i < all_points.size(); i++) {
   		Edge sweep = all_points.get(so.indexes[i]).next;
   		if (sweep != null && sweep.crosses(e) == true && sweep.p1 != p1 && sweep.p2 != p1) {
   			println("Adicionada aresta: " + sweep.toString());
   			sweep_line.add(sweep);
   		}
   	}
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
		} else {
			sweep_line.add(e1);
		}
		println("SWEEP LINE " + sweep_line.toString());
	}
	if (e2.p1 != current_edge.p1 && e2.p2 != current_edge.p1) {
		println("Aresta 2 " + e2.toString() + " ; Vértice " + e2p.toString());
		if (current_edge.right(e2p) == true) {
			sweep_line.remove(e2);
		} else {
			sweep_line.add(e2);
		}
		println("SWEEP LINE " + sweep_line.toString());
	}
	println("FIM");
}

void check_visibles_vertexes(int point, SortOder so) {
	/* check for visible vertexes from point. 
	   Add edges for all that are visible and run the animation */ 
	println("Verificando vértice " + all_points.get(point).toString());
	/* inicializa conjunto com arestas que cruzam com a reta p1 = point */
	init_sweep_line(point, so);
   	vgba.start_animation(current_point, so, sweep_line);
}

void check_intersections(Edge current_edge) {
	println("Checando interseções de: " + current_edge.toString());
}

void start_algorithm() {
	set_mode("build_graph");
	sweep_line = new Set();
	all_points = get_all_points(polys); 
	all_points.add(start);
	all_points.add(end);
	
	vgba = new VisibilityGraphBuildAnimation(all_points);
	current_point = 0;
	SortOrder so = sort_around_point(all_points, current_point);
	check_visibles_vertexes(current_point, so);
}

void setup() {
	size(500, 500);
	start[0] = start[1] = end[0] = end[1] = -1;
}

void draw() {
	background(255);
	draw_polys();	
	
	
	fill(0, 255, 0);
	ellipse(start.x, start.y, 5, 5);
	fill(255, 0, 0);
	ellipse(end.x, end.y, 5, 5);
	
	
	if (mode == "build_graph") {
		vgba.draw();
		if (vgba.is_finished()) {
			current_point++;
			if (current_point < all_points.size()) {
				SortOrder so = sort_around_point(all_points, current_point);
				check_visibles_vertexes(current_point, so);
			} else {
				set_mode("shortest_path");
			}
		}
		if (vgba.changed_edge()) {
			/* olha se cruza com alguem da linha de varredura */
			check_intersections(vgba.current_edge());
		} else if (vgba.changed_to_update_sweep_line()) {
			update_sweep_line(vgba.point_counter, vgba.so, vgba.current_edge());
		}
		
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
	start.y = y;
}

void set_end(int x, int y) {
	end.x = x;
	end.y = y;
}

Point get_start() {
	return start;
}

Point get_end() {
	return end;
}
