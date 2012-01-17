
float get_slope(Edge e) {
	return (e.p2.y - e.p1.y)/(e.p2.x - e.p1.x);;
}

Point edge_intersect_point(Edge e1, Edge e2) {
	/* line equation: y = ax + b */
	float a1 = -get_slope(e1);
	float a2 = -get_slope(e2);
	float b1 = e1.p1.y + a1 * e1.p1.x;
	float b1 = e2.p1.y + a2 * e2.p1.x;
	
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
	
	float calculate_key(Point p) {
		return 0;
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
		while(ptr.parent != null && ptr == ptr.parent.left) {
			ptr = ptr.parent;
		} 
		if (ptr.parent != null) {
			ptr.key = p.key;
			ptr.value = p.value;
		}
	}
	
	void add(Edge e, float key) {
		println("Add: " + e + " key : " + key);
		/*if (root != null) {
			BinaryTreeNode p = find(key);
			println("FIND: " + p);
			if (p.value.right(e.p1)) {
				BinaryTreeNode left = new BinaryTreeNode(key, e, null, null, p);
				BinaryTreeNode right = new BinaryTreeNode(p.key, p.value, null, null, p);
				p.left = left;
				p.right = right;
				p.key = left.key;
				p.value = left.value;
				fixUp(p.right);
			} else {
				BinaryTreeNode right = new BinaryTreeNode(key, e, null, null, p);
				BinaryTreeNode left = new BinaryTreeNode(p.key, p.value, null, null, p);
				p.left = left;
				p.right = right;
			}
		} else {
			root = new BinaryTreeNode(key, e, null, null, null);
		}*/
		size++;
	}
	
	Edge find(float key) {
		BinaryTreeNode ptr = root;
		while (ptr != null && !ptr.isLeaf()) {
			float ptr_key = ptr.calculate_key();
			if (ptr <= ptr_key) {
				ptr = ptr.left;
			} else {
				ptr = ptr.right;
			}
		} 
		return ptr;
	}
	
	boolean remove(Edge e) {
		/*BinaryTreeNode p = findE(e.p1);
		BinaryTreeNode parent = p.parent;
		if (p == parent.left) {
			parent.key = p.key;
			parent.value = p.value;
			fixUp(parent);
		}
		parent.left = parent.right = null;*/
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
		return p;
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