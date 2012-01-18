
float get_slope_y(Edge e) {
	return ((float) (e.p2.y - e.p1.y))/(e.p2.x - e.p1.x);
}

Point edge_intersect_point(Edge e1, Edge e2) {
	if (e2.p1.x == e2.p2.x) return edge_intersect_point(e2, e1);
	if (e1.p1.x == e1.p2.x) {
		/* trata caso em que o get_slope_y daria divisao por 0 */
		float a2 = get_slope_y(e2);
		float b2 = e2.p1.y - a2 * e2.p1.x;
		float inter_y = a2 * e1.p1.x + b2;
		return new Point(e1.p1.x, inter_y);
	}	
	/* line equation: y = ax + b */
	float a1 = get_slope_y(e1);
	float a2 = get_slope_y(e2);
	float b1 = e1.p1.y - a1 * e1.p1.x;
	float b2 = e2.p1.y - a2 * e2.p1.x; 
	
	float inter_x = (b2 - b1)/(a1 - a2);
	float inter_y = a1 * inter_x + b1;
	return new Point(inter_x, inter_y);
}

class BinaryTreeNode {
	Object value;
	public BinaryTreeNode left, right, parent;
	
	public BinaryTreeNode(Object value, BinaryTreeNode left, BinaryTreeNode right, BinaryTreeNode parent) {
		this.value = value;
		this.left = left;
		this.right = right;
		this.parent = parent;
	}
	
	boolean isLeaf() {
		return left == null && right == null;
	}
	
	String toString() {
		return value.toString();
	}
	
	float calculate_key(Edge e) {
		Point crossing = edge_intersect_point(e, value);
		float key = dist(e.p1.x, e.p1.y, crossing.x, crossing.y);
		return key;
	}
}

class BinaryTree extends Set {

	BinaryTreeNode root;
	int size;
	Point origin;
	
	BinaryTree(Point origin) {
		root = null;
		size = 0;
		this.origin = origin;
	}
	
	float getKey(Edge e, Edge current) {
		Point crossing = edge_intersect_point(e, current);
		float key = dist(origin.x, origin.y, crossing.x, crossing.y);
		return key;
	}
	
	void fixUp(BinaryTreeNode p) {
		BinaryTreeNode ptr = p;
		if (ptr == null) return;
		while(ptr.parent != null && ptr == ptr.parent.right) {
			ptr = ptr.parent;
		} 
		if (ptr.parent != null) {
			ptr.parent.value = p.value;
		}
	}
	
	float getKeyForward(Edge e, Edge current) {
		Edge new_current = new Edge(current.p1, current.p2);
		Point new_p2 = new Point(current.p2.x - current.p1.x, current.p2.y - current.p1.y);
		new_p2.x = new_p2.x * cos(-QUARTER_PI/10) + new_p2.y * sin(-QUARTER_PI/10) + current.p1.x;
		new_p2.y =  - new_p2.x * sin(-QUARTER_PI/10) + new_p2.y * cos(-QUARTER_PI/10) + current.p1.y;
		new_current.p2 = new_p2;
		println(new_p2);
		return getKey(e, new_current);
	}	
	
	void add(Edge e, Edge current) {
		float key = getKey(e, current);
		println("Add: " + e + " key : " + key);
		if (root != null) {
			BinaryTreeNode p = find(e, current);
			println("Found: " + p + ": " + p.calculate_key(current));
			println(this);
			float ptr_key = p.calculate_key(current);
			if (abs(key - ptr_key) < 0.0001) {
				/* Se caiu aqui entao estou adicionando a segunda aresta de um "bico" 
				   Deste modo, preciso "avancar" um pouco no sentido da aresta para saber qual esta na frente	
				*/
				key = getKeyForward(e, current);  
				ptr_key = getKeyForward(p.value, current);
				println("New Key: " + key + ", New ptr_key " + ptr_key);
			}
			if (key < ptr_key) {
				BinaryTreeNode left = new BinaryTreeNode(e, null, null, p);
				BinaryTreeNode right = new BinaryTreeNode(p.value, null, null, p);
				p.left = left;
				p.right = right;
				p.value = left.value;
			} else {
				BinaryTreeNode left = new BinaryTreeNode(p.value, null, null, p);
				BinaryTreeNode right = new BinaryTreeNode(e, null, null, p);
				p.left = left;
				p.right = right;
				fixUp(p.right);
			}
			println(this);
		} else {
			root = new BinaryTreeNode(e, null, null, null);
		}
		size++;
	}
	
	Edge find(Edge e, Edge current) {
		BinaryTreeNode ptr = root;
		float key = getKey(e, current);
		while (ptr != null && !ptr.isLeaf()) {
			float ptr_key = ptr.calculate_key(current);
			println("Find: " + ptr + ", key: " + ptr_key);
			if (key == ptr_key && !ptr.isLeaf() && (ptr.left.isLeaf() || ptr.right.isLeaf())) {
				if (ptr.left.value.equals(e)) ptr = ptr.left;
				else if (ptr.right.value.equals(e))  ptr = ptr.right;
				else ptr = ptr.left;
			} else if (key <= ptr_key) {
				ptr = ptr.left;
			} else {
				ptr = ptr.right;
			}
		} 
		return ptr;
	}
	
	boolean remove(Edge e, Edge current) {
		float key = getKey(e, current);
		println("Remove: " + e + ", key: " + key);
		BinaryTreeNode p = find(e, current);
		println("Find: " + p);
		println(this);
		if (p == root) {
			root = null;
		} else {
			BinaryTreeNode parent = p.parent;
			if (parent == root) {
				BinaryTreeNode new_parent;
				if (p == parent.left) new_parent = parent.right;
				else if (p == parent.right) new_parent = parent.left;
				new_parent.parent = null;
				root = new_parent;
			} else {
				BinaryTreeNode rest, new_parent;
				if (p == parent.left) {
					rest = parent.right;
				} else {
					rest = parent.left;
				}
				new_parent = parent.parent;
				rest.parent = new_parent;
				if (parent == new_parent.left) {
					new_parent.left = rest;
					BinaryTreeNode rightmost = new_parent.left;
					while (!rightmost.isLeaf()) {
						rightmost = rightmost.right;
					}
					fixUp(rightmost);
				} else if (parent == new_parent.right) {
					println("Right of new_parent");
					new_parent.right = rest;
					BinaryTreeNode rightmost = new_parent;
					while (!rightmost.isLeaf()) {
						rightmost = rightmost.right;
					}
					fixUp(rightmost);
				}
			}
		}
		println(this);
		size--;
	}
	
	int size() {
		return size;
	}
	
	Edge getNearestEdge() {
		BinaryTreeNode p = root;
		if (p == null) return null;
		while (p.left != null) {
			p = p.left;
		}	
		return p.value;
	}
	
	String print(BinaryTreeNode p) {
		if (p == null) return "";
		String l = print(p.left);
		String r = print(p.right);
		if (p == root) {
			return "[" + l + "] R" + p.toString() + " [" + r + "]";
		} else {
			return "[" + l + "] " + p.toString() + " [" + r + "]";
		}
		
	}
	
	String toString() {
		return print(root);
	}

}