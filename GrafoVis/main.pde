public String mode = "polygon";

Point start = new Point(-1, -1);
Point end = new Point(-1, -1);
ArrayList all_points;
Set sweep_line = null;

int current_point_for_visgraph = 0;
VisibilityGraphBuildAnimation vgba = null;

void set_mode(String m) {
	mode = m;
}

void init_sweep_line(int point, SortOrder so) {
	sweep_line = new Set();
	Point p1 = all_points.get(point); 
	Edge e = new Edge(p1, new Point(100000000, p1.y));
	for (int i = 0; i < all_points.size(); i++) {
   		Edge sweep = all_points.get(so.indexes[i]).next;
   		if (sweep != null && sweep.crosses(e) == true && sweep.p1 != p1 && sweep.p2 != p1) {
   			println(sweep);
   			sweep_line.add(sweep);
   		}
   	}
}

void update_sweep_line(int point_so, SortOrder so) {
	/* remove as arestas que tem point_so como ponto extremo e que estão abaixo da sweep_line */
	
	/* adiciona as arestas que tem point_so como ponto extremo e que estão acima da sweep_line */ 
}

void check_visibles_vertexes(int point, SortOder so) {
	/* check for visible vertexes from point. 
	   Add edges for all that are visible and run the animation */ 
	println("CHECK VERTEX " + point);
	/* inicializa conjunto com arestas que cruzam com a reta p1 = point */
	init_sweep_line(point, so);
   	for (int i = 0; i < all_points.size(); i++) {
   		Edge sweep = new Edge(all_points.get(point), all_points.get(so.indexes[i]) );
   	}
   	vgba.start_animation(current_point_for_visgraph, so, sweep_line);
}

void start_algorithm() {
	set_mode("build_graph");
	sweep_line = new Set();
	all_points = get_all_points(polys); 
	all_points.add(start);
	all_points.add(end);
	
	vgba = new VisibilityGraphBuildAnimation(all_points);
	current_point_for_visgraph = 0;
	SortOrder so = sort_around_point(all_points, current_point_for_visgraph);
	check_visibles_vertexes(current_point_for_visgraph, so);
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
			current_point_for_visgraph++;
			if (current_point_for_visgraph < all_points.size()) {
				SortOrder so = sort_around_point(all_points, current_point_for_visgraph);
				check_visibles_vertexes(current_point_for_visgraph, so);
			} else {
				set_mode("shortest_path");
			}
		}
	}
}

void mouseClicked() {
	if (mode == "polygon") {
		click_polys();
	} else if (mode == "start_point") {
		start.x = mouseX;
		start.y = mouseY;
		mode = "polygon";
	} else if (mode == "end_point") {
		end.x = mouseX;
		end.y = mouseY;
		mode = "polygon";
	}
}
