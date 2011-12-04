



class VisibilityGraphBuildAnimation {
	int last_point = 0;
	
	int frame_count = 0;
	int max_frame = 10;
	
	ArrayList all_points = null;
	SortOrder so;
	Set sweep_line = null;
	
	int current_point;
	int point_counter;
	
	String mode; // INTERSECTIONS OR UPDATE SWEEP LINE
	boolean run = false;
	
	public VisibilityGraphBuildAnimation(ArrayList all_points) {
		this.all_points = all_points;
	}
	
	public void start_animation(int point, SortOrder so, Set sweep_line) {
		this.current_point = point;
		this.point_counter = -1;
		this.so = so;
		this.sweep_line = sweep_line;
		this.run = true;
		this.mode = "INTERSECTIONS";
	}
	
	public boolean is_finished() {
		return !this.run;
	}
	
	public boolean changed_edge() {
		return this.run && this.point_counter >= 0 && this.frame_count == 0 && mode == "INTERSECTIONS";
	}
	
	public boolean changed_to_update_sweep_line() {
		return this.frame_count == 0 && mode == "UPDATE_SWEEP_LINE" && point_counter >= 0;
	}
	
	public Edge current_edge() {
		Point current, next;
		current = (Point) all_points.get(current_point);
		if (point_counter == -1) {
			next = new Point(1000000, current.y);
		} else {
			next = (Point) all_points.get(so.indexes[point_counter]);
		}
		return new Edge(current, next);
	}
	
	public void draw_intersections() {
		frame_count++;
		if (frame_count >= max_frame) {
			frame_count = 0;
			mode = "UPDATE_SWEEP_LINE";
		}
	}
	
	public void draw_update_sweep_line() {
		frame_count++;
		if (frame_count >= max_frame) {
			frame_count = 0;
			point_counter++;
			if (so.indexes[point_counter] == current_point) point_counter++;
			if (point_counter >= all_points.size()) {
				run = false;
			}
			mode = "INTERSECTIONS";
		}
	}
	
	public void draw_line() {
		stroke(0, 255, 0);
		fill(0, 255, 0);
		
		Point current;
		current = (Point) all_points.get(current_point);
		if (point_counter == -1) {
			line(current.x, current.y, 1000, current.y);
		} else {
			next = (Point) all_points.get(so.indexes[point_counter]);
			line(current.x, current.y, next.x, next.y);
		}
		ellipse(current.x, current.y, 5, 5);
	}
	
	public void draw_sweep_line() {
		stroke(255, 0, 0);
		for (int i = 0; i < sweep_line.size(); i++) {
			Edge e = sweep_line.get(i);
			e.draw();
		}
	}

	public void draw() {
		if (this.run == true) {
			draw_line();
			draw_sweep_line();
			if (mode == "INTERSECTIONS") {
				draw_intersections();
			} else {
				draw_update_sweep_line();
			}			
		}
	}
}

class DijkstraAnimation {
	
	Graph g;
	PriorityQueue pq;
	ArrayList path_length;
	ArrayList visited;
	
	int frame_count = 0;
	int max_frame = 30;
	
	public DijkstraAnimation(Graph g, PriorityQueue pq, ArrayList path_length) {
		this.g = g;
		this.pq = pq;
		this.path_length = path_length;
		this.visited = new ArrayList();
	}
	
	public boolean changed_vertex() {
		return frame_count == 0;
	}
	
	public void add_visited_vertex(int i) {
		this.visited.add(i);
	}
	
	public void draw() {
		frame_count++;
		if (frame_count == max_frame) {
			frame_count = 0;
		}
		
		// pinta vertices na fila
		
		// pinta vertices visitados
		fill(0, 255, 0);
		for (int i = 0; i < visited.size(); i++) {
			Point p = g.all_points.get(visited.get(i));
			ellipse(p.x, p.y, 5, 5)
		}
		// pinta distâncias atuais para cada vertice
		Font font = loadFont("Arial"); 
		textFont(font); 
		
		fill(255, 0, 255);
		for (int i = 0; i < g.all_points.size(); i++) {
			Point p = g.all_points.get(i);
			int d = ((int) (path_length.get(i) * 100)) / 100;
			String t = d.toString(); 
			text(t, p.x - textWidth(t), p.y);
		}
	}
}