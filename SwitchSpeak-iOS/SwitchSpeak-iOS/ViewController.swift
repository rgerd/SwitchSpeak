//
//  ViewController.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/5/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//


import UIKit

/*
a Node would always be a non-leaf node in the 'Tree' data structure
*/
class Node{
	var parentNode: Node?			//	the parent node could be nil
	var childNodes: [Node] = []		//	initialised with an empty child list
	
	init()
	{
		self.parentNode = nil
	}
	
	/*
	add a single input node to the childNodes list
	*/
	func addChild(child: Node){
		childNodes.append(child)
	}
	
	/*
	append a list of nodes to the childNodes list
	*/
	func addChildren(children: [Node]){
		childNodes = childNodes + children
	}
	/*
	Highlight all the buttons present in the subtree rooted at self
	*/
	func highlightSubTree(){
		
		for childNode in self.childNodes{
			childNode.highlightSubTree()
		}
	}
	
	func unHighlightSubTree(){
		
		for childNode in self.childNodes{
			childNode.unHighlightSubTree()
		}
	}
	
}

/*
a ButtonNode would always be a leaf node in the 'Tree' data structure
*/
class ButtonNode: Node{
	var button = UIButton(type: UIButtonType.custom)
	
	init(button: UIButton) {
		self.button = button
		super.init()
	}
	
	override func highlightSubTree(){
		//	for now a button is highlighted with a change in background color
		self.button.backgroundColor = UIColor.blue
	}
	
	override func unHighlightSubTree(){
		self.button.backgroundColor = UIColor.gray
	}
}

class Tree {
	var rootNode: Node?
	
	init(root: Node){
		self.rootNode = root
	}
}

/*
This function returns a tree with an n degree root node, where each of its children nodes have m children each
This corresponds to the row-column scanning of the nXm 2D grid
*/
func createNxMTree (n: Int ,m: Int) -> Tree{
	
	let rnode = Node()
	let T = Tree(root: rnode)
	
	for i in 1...n{
		let interNode = Node()	//	non-leaf node
		rnode.addChild(child: interNode)
		
		for j in 1...m{
			let button = UIButton()
			//	next we will set the attributes of the button
			button.setTitle("(\(i),\(j))", for: .normal)	//	arbitrary title for now
			button.frame = CGRect(x: 110*i-50, y: 140*j, width: 100, height: 100)	//	some arbitrary values
			button.backgroundColor = UIColor.lightGray
			let leafNode = ButtonNode(button: button)
			interNode.addChild(child: leafNode)
		}
	}
	return T
}

class ViewController: UIViewController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let T = createNxMTree(n: 3, m: 4)
		addTreeToView(T: T)
		
	}
	
	/*
	add all the buttons present in the leaf nodes of the
	input tree to the view
	*/
	func addTreeToView(T: Tree){
		addSubTreeToView(node: T.rootNode!)
	}
	
	/*
	add all the buttons present in the leaf nodes of the
	tree rooted at node to the view
	*/
	func addSubTreeToView(node: Node){
		
		//	if node is of an object of class ButtonNode i.e. it is a leaf node
		if let curNode = node as? ButtonNode{
			view.addSubview(curNode.button)
			return
		}
		
		for childnode in node.childNodes{
			addSubTreeToView(node: childnode)
		}
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

