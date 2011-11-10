



class VisibilityGraphBuildAnimation {
	int last_point = 0;
	
	int frame_count = 0;
	int max_frame = 30;
	
	ArrayList all_points = null;
	SortOrder so;
	Set sweep_line = null;
	
	int current_point;
	int point_counter;
	
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
	}
	
	public boolean is_finished() {
		return !this.run;
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
			stroke(0, 255, 0);
			fill(0, 255, 0);
			
			Point current, next;
			current = (Point) all_points.get(current_point);
			if (point_counter == -1) {
				next = new Point(1000000, current.y);
			} else {
				next = (Point) all_points.get(so.indexes[point_counter]);
			}
			ellipse(current.x, current.y, 5, 5);
			line(current.x, current.y, next.x, next.y);
			frame_count++;
			if (frame_count >= max_frame) {
				frame_count = 0;
				point_counter++;
				if (so.indexes[point_counter] == current_point) point_counter++;
				if (point_counter >= all_points.size()) {
					run = false;
				}
			}
			draw_sweep_line();
		}
	}
}