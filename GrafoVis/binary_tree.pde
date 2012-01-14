class BinaryTreeNode {
	double value;
	public BinaryTreeNode left, right;
	
	public BinaryTreeNode(double value, BinaryTreeNode left, BinaryTreeNode right) {
		this.value = value;
		this.left = left;
		this.right = right;
	}
	
	void add(Edge e) {
	
	}
	
	void remove(Edge e) {
		
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
	
	void add(Edge e) {
		if (root != null) {
		
		} else {
			root = new BinaryTree(calculateValue(e), null, null);
		}
	}
	
	int size() {
		return size;
	}
	
	Object get(int i) {
		return null;
	}
	
	boolean remove(Edge e) {
		return false;
	}

}