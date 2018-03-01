//
//  Node.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit

/*
a Node would always be a non-leaf node in the 'Tree' data structure
*/
class Node {
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





