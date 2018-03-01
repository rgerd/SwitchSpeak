//
//  ViewController.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/5/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//


import UIKit



class stash {
	
	var items: [item]
	
	init() {
		self.items = []
		
	}
	
	
	func add( new_item:item ){
		items.append(new_item)
		new_item.Set_Loc_Col(index:items.count-1 )
	}
	
	
	func delete(){
		items.removeLast()
	}
	
	func add(new_item : String) {
		let newitem = item(content: new_item)
		add(new_item: newitem)
	}
	
	
	
}

class item {
	var button : UIButton
	
	init(content : String) {
		button = UIButton(type: UIButtonType.system)
		button.setTitle(content, for: UIControlState.normal)
		//  button.backgroundColor = UIColor.darkGray
		
	}
	
	func Set_Loc_Col(index : Int ){
		button.frame = CGRect(x:10+(index % 5)*80, y:40*(index/5+1), width:80, height:40)
		if index % 2 == 0{
			button.backgroundColor = UIColor.darkGray
			
		}
		else{
			button.backgroundColor = UIColor.lightGray
		}
		
	}
	
}

class ViewController: UIViewController {
	
	
	@IBOutlet weak var TapButton: UIButton!
	
	
	var curNode = Node()	//	currently the node in the tree we are at while scanning
	var childNumber: Int = 0 //	this will represent the index of highlighted child of the curNode
	//	the result of the scanning procedure will be stored
	//	in curNode and childNumber variables
	var flag: Bool = false	//	this is set to true whenever curNode is updated
	var breadcrum = stash()
	var factory = TreeFactory()
	var T = Tree()
	
	//	the following attributes can be input from user settings
	var timeDelay: Double = 1.0	//	time delay during scanning
	var rows = 3, cols = 4	//	dimension of the 2D grid
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.T = factory.treeForRowColumnScanning(rows: rows, cols: cols)
		addTreeToView(T: T)
		view.bringSubview(toFront: TapButton)
		curNode = T.rootNode!
		selectSubTree()
		
	}
	
	
	@IBAction func TapButton(_ sender: Any) {
		
		//	select a subtree from the current subtree stored in curNode
		if (curNode.childNodes.count > 0) //	i.e. we have not yet reached a leafnode
		{
			curNode = curNode.childNodes[childNumber]
			childNumber = 0
			flag = true
			if(curNode.childNodes.count == 0){
				let choice = (curNode as? ButtonNode)?.button.title(for: .normal)
				breadcrum.add(new_item: choice!)
				addStashToView()
				curNode = (T.rootNode)!
			}
		}
	}
	
	
	
	func addStashToView (){
		for item in breadcrum.items{
			view.addSubview(item.button)
		}
		
	}
	

	
	/*
	Highlight the childNumber'th child node of the curNode
	*/
	func selectSubTree(){
		
		print ("child number:\(childNumber)")
		curNode.childNodes[childNumber].highlightSubTree()
		let previousCurNode: Node = curNode
		
		delay(self.timeDelay){
			
			//	we will unhighlight the previously highlighted subtree iff the curNode is
			//	not a leaf node
			if (self.curNode.childNodes.count != 0){
				previousCurNode.unHighlightSubTree()
			}
			
			//	check if the cur node has changed
			if (!self.flag){
				
				if (self.childNumber == self.curNode.childNodes.count-1){
					//	i.e. we had just now highlighted the last child node of curNode
					self.childNumber = 0
				}
				else{
					self.childNumber += 1
				}
			}else{
				self.flag = false
			}
			
			if (self.curNode.childNodes.count != 0) {
				//	i.e. we have not yet reached a leaf node while scanning
				self.selectSubTree()
			}
		}
		
	}
	
	//	ensures a time delay for executing a block of code
	func delay(_ seconds: Double, completion: @escaping () -> ()) {
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			completion()
		}
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

