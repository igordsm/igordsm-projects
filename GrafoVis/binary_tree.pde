class BinaryTreeNode {
	double key;
	Object value;
	public BinaryTreeNode left, right, parent;
	
	public BinaryTreeNode(double key, Object value, BinaryTreeNode left, BinaryTreeNode right, BinaryTreeNode parent) {
		this.value = value;
		this.key = key;
		this.left = left;
		this.right = right;
		this.parent = parent;
	}
	
	boolean isLeaf() {
		return left == null && right == null;
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
	
	private double calculateValue(Edge e) {
		return 0.0;
	}
	
	void fixUp(BinaryTreeNode p) {
		BinaryTreeNode ptr = p.parent;
		while(ptr.parent != null || ptr == ptr.parent.left) {
			ptr = ptr.parent;
		} 
		if (ptr.parent != null) {
			ptr.key = p.key;
			ptr.value = p.value;
		}
	}
	
	void add(Edge e) {
		double key = calculateValue(e);
		if (root != null) {
			BinaryTreeNode p = find(key);
			if (key <= p.value) {
				BinaryTreeNode left = new BinaryTreeNode(key, e, null, null, p);
				BinaryTreeNode right = new BinaryTreeNode(p.key, p.value, null, null, p);
				p.left = left;
				p.right = right;
			} else {
				BinaryTreeNode right = new BinaryTreeNode(key, e, null, null, p);
				BinaryTreeNode left = new BinaryTreeNode(p.key, p.value, null, null, p);
				p.left = left;
				p.right = right;
				p.key = right.key;
				p.value = right.value;
				fixUp(p.right);
			}
		} else {
			root = new BinaryTreeNode(key, e, null, null, null);
		}
	}
	
	boolean remove(Edge e) {
		double key = calculateValue(e);
		BinaryTreeNode p = find(key);
		
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
	
	Edge find(double distance) {
		BinaryTreeNode p = root;
		while (p != null) {
			if (p.isLeaf()) {
				break;
			} else {
				if (p.value >= distance) {
					p = p.left;
				} else {
					p = p.right;
				}
			}
		}
		return p;
	}
	
	boolean remove(Edge e) {
		return false;
	}

}