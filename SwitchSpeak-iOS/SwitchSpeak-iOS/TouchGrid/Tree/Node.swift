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
	var parentNode:Node?			//	the parent node could be nil
	var childNodes:[Node] = []		//	initialised with an empty child list
	var dummy:Bool = false

	init() {
		self.parentNode = nil
	}
	
	/*
	add a single input node to the childNodes list
	*/
	func addChild(child: Node) {
		childNodes.append(child)
	}
	
	/*
	append a list of nodes to the childNodes list
	*/
	func addChildren(children: [Node]) {
		childNodes = childNodes + children
	}
	/*
	Highlight all the buttons present in the subtree rooted at self
	*/
    func highlightSubTree() {
        for childNode in self.childNodes {
            childNode.highlightSubTree()
        }
    }
	
	func unHighlightSubTree() {
		for childNode in self.childNodes {
			childNode.unHighlightSubTree()
		}
	}
    

    // If this node only has one non-dummy child node, that node is returned by this function; otherwise the function returns the node itself
    func mergeNode() -> Node {
        var nonDummyChild:Node? = nil
        
        for childNode in self.childNodes {
            if !childNode.dummy {
                if nonDummyChild == nil {
                    nonDummyChild = childNode
                } else {
                    return self;
                }
            }
        }
        
        // We might still have never encountered a non-dummy child
        return nonDummyChild == nil ? self : nonDummyChild!
    }
    
    // it will make every child node shrink if that child has only single nonDummy child node
    func shrinkChildren() {
        for (index, childNode) in childNodes.enumerated() {
            childNodes[index] = childNode.mergeNode()
        }
    }
    
    //    return the number of non-dummy child nodes
    func countNonDummyChildNodes() -> Int {
        var count: Int = 0
        for index in 0...(self.childNodes.count - 1) {
            if !self.childNodes[index].dummy {
                count += 1
            }
        }
        return count
    }
}





