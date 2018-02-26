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
		self.button.backgroundColor = UIColor.lightGray
	}
}

class Tree {
	var rootNode: Node?
	
	init(root: Node){
		self.rootNode = root
	}
}


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
			button.frame = CGRect(x: 110*j-50, y: 140*i, width: 100, height: 100)	//	some arbitrary values
			button.backgroundColor = UIColor.lightGray
			let leafNode = ButtonNode(button: button)
			interNode.addChild(child: leafNode)
		}
	}
	return T
}

class ViewController: UIViewController {
	
	var curNode = Node()	//	currently the node in the tree we are at while scanning
	var childNumber: Int = 0 //	this will represent the index of highlighted child of the curNode
	//	the result of the scanning procedure will be stored
	//	in curNode and childNumber variables
	var timeDelay: Double = 1.0	//	time delay during scanning
	var flag: Bool = false	//	this is set to true whenever curNode is updated
    var breadcrum = stash();
    var T = createNxMTree(n: 4, m: 3)

	override func viewDidLoad() {
		super.viewDidLoad()
		addTreeToView(T: T)
		curNode = T.rootNode!
        selectSubTree()
        
    }
    
    
    func addStashToView (){
            for item in breadcrum.items{
                view.addSubview(item.button)
            }
        
    }
        
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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

