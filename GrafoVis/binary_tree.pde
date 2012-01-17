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
	
	String toString() {
		return value.toString();
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
		while(ptr.parent != null && ptr == ptr.parent.left) {
			ptr = ptr.parent;
		} 
		if (ptr.parent != null) {
			ptr.key = p.key;
			ptr.value = p.value;
		}
	}
	
	void add(Edge e) {
		if (root != null) {
			BinaryTreeNode p = findE(e);
			if (p.value.right(e.p1)) {
				BinaryTreeNode left = new BinaryTreeNode(calculateValue(key), e, null, null, p);
				BinaryTreeNode right = new BinaryTreeNode(p.key, p.value, null, null, p);
				p.left = left;
				p.right = right;
				p.key = left.key;
				p.value = left.value;
				fixUp(p.right);
			} else {
				BinaryTreeNode right = new BinaryTreeNode(calculateValue(key), e, null, null, p);
				BinaryTreeNode left = new BinaryTreeNode(p.key, p.value, null, null, p);
				p.left = left;
				p.right = right;
			}
		} else {
			root = new BinaryTreeNode(key, e, null, null, null);
		}
	}
	
	boolean remove(Edge e) {
		BinaryTreeNode p = findE(e.p1);
		BinaryTreeNode parent = p.parent;
		if (p == parent.left) {
			parent.key = p.key;
			parent.value = p.value;
			fixUp(parent);
		}
		parent.left = parent.right = null;
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
	
	Edge findE(Point p) {
		BinaryTreeNode p = root;
		while (p != null) {
			if (p.isLeaf()) {
				break;
			} else {
				if (p.value.left(p) || p.value.colinear(p)) {
					p = p.left;
				} else {
					p = p.right;
				}
			}
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