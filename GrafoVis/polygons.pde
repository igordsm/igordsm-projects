
ArrayList polys = new ArrayList();
Polygon poly = new Polygon();

void draw_polys() {
	for (int i = 0; i < polys.size(); i++) {
		Polygon p = (Polygon) polys.get(i);
		p.draw();
	}
	poly.draw();
}

void click_polys() {
	poly.add_point(mouseX, mouseY);
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