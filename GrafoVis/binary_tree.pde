
float get_slope_y(Edge e) {
	return ((float) (e.p2.y - e.p1.y))/(e.p2.x - e.p1.x);
}

Point edge_intersect_point(Edge e1, Edge e2) {
	if (e2.p1.x == e2.p2.x) return edge_intersect_point(e2, e1);
	if (e1.p1.x == e1.p2.x) {
		/* trata caso em que o get_slope_y daria divisao por 0 */
	}	
	/* line equation: y = ax + b */
	float a1 = get_slope_y(e1);
	float a2 = get_slope_y(e2);
	float b1 = e1.p1.y - a1 * e1.p1.x;
	float b2 = e2.p1.y - a2 * e2.p1.x;
	/*println(e1);
	println("E1 : y = " + a1 + "x + " + b1);
	println(e2);
	println("E2 : y = " + a2 + "x + " + b2);*/ 
	
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
	
	void fixUp(BinaryTreeNode p) {
		BinaryTreeNode ptr = p.parent;
		if (ptr == null) return;
		while(ptr.parent != null && ptr == ptr.parent.left) {
			ptr = ptr.parent;
		} 
		if (ptr.parent != null) {
			ptr.key = p.key;
			ptr.value = p.value;
		}
	}
	
	void add(Edge e, Edge current) {
		Point crossing = edge_intersect_point(e, current);
		float key = dist(origin.x, origin.y, crossing.x, crossing.y);
		println("Add: " + e + " key : " + key);
		if (root != null) {
			BinaryTreeNode p = find(key, current);
			println("FIND: " + p + ": " + p.calculate_key(current));
			if (key <= p.calculate_key(current)) {
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
		} else {
			root = new BinaryTreeNode(e, null, null, null);
		}
		size++;
	}
	
	Edge find(float key, Edge current) {
		BinaryTreeNode ptr = root;
		while (ptr != null && !ptr.isLeaf()) {
			float ptr_key = ptr.calculate_key(current);
			println("Find: " + ptr + ", key: " + ptr_key);
			if (key <= ptr_key) {
				ptr = ptr.left;
			} else {
				ptr = ptr.right;
			}
		} 
		return ptr;
	}
	
	boolean remove(Edge e, Edge current) {
		Point crossing = edge_intersect_point(e, current);
		float key = dist(origin.x, origin.y, crossing.x, crossing.y);
		println("Remove: " + e + ", key: " + key);
		BinaryTreeNode p = find(key, current);
		println("Find: " + p);
		if (p == root) {
			root = null;
		} else {
			BinaryTreeNode parent = p.parent;
			if (p == parent.left) {
				parent.value = p.value;
				fixUp(parent);
			}
			parent.left = parent.right = null;
		}
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
		return "[" + l + "] " + p.toString() + " [" + r + "]";
	}
	
	String toString() {
		return print(root);
	}

}