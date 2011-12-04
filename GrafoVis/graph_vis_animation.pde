



class VisibilityGraphBuildAnimation {
	int last_point = 0;
	
	int frame_count = 0;
	int max_frame = 30;
	
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
	ArrayList dist;
	
	DijkstraAnimation(Graph g, PriorityQueue pq, ArrayList dist) {
		this.g = g;
		this.pq = pq;
		this.dist = dist;
	}
	
	public void draw() {
		
	}
}