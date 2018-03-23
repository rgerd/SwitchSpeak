//
//  TouchGrid.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 3/12/18.
//  Original code by Jaspal Singh.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit

class TouchGrid {
    var curNode = Node()    //    currently the node in the tree we are at while scanning
    var childNumber: Int = 0 //    this will represent the index of highlighted child of the curNode
    //    the result of the scanning procedure will be stored
    //    in curNode and childNumber variables
    var curNodeUpdated: Bool = false    //    this is set to true whenever curNode is updated
    
    var userId:Int!
    var settings:UserSettings!
    private var viewContainer:UIView!
    private var buttonTree:Tree!
    
    init(userId:Int, viewContainer:UIView) {
        self.userId = userId
        self.settings = GlobalSettings.userSettings[userId]
        self.viewContainer = viewContainer
        
        self.buttonTree = TreeFactory.buildTree(type: settings.scanType, size: settings.getGridSize(), dummyNum: 0)
        
        let (rows, cols) = settings.getGridSize()
        //    there are three magic numbers in the below function call
        //    need to modify these magic numbers to appropriate variables
        self.buttonTree.setFrameSizeForTree (row: rows, col: cols, screenWidth: Int(UIScreen.main.bounds.width), screenHeight: Int(UIScreen.main.bounds.height), topBarHeight: 140, maxButtonHeight: 200, maxButtonWidth: 200)
        
        addTreeToView(T: buttonTree)
        curNode = buttonTree.rootNode!
    }
    
    /*
     add all the buttons present in the leaf nodes of the
     input tree to the view
     */
    func addTreeToView(T: Tree) {
        addSubTreeToView(node: T.rootNode!)
    }
    
    /*
     add all the buttons present in the leaf nodes of the
     tree rooted at node to the view
     */
    func addSubTreeToView(node: Node) {
        //    if node is of an object of class ButtonNode i.e. it is a leaf node
        if let curNode = node as? ButtonNode {
            viewContainer.addSubview(curNode.button)
            return
        }
        
        for childnode in node.childNodes {
            addSubTreeToView(node: childnode)
        }
    }
    
    /*
     Highlight the childNumber'th child node of the curNode
     */
    func selectSubTree() {
        curNode.childNodes[childNumber].highlightSubTree()
        let previousCurNode: Node = curNode
		var timeDelay = 0.0
		if (!curNode.childNodes[(childNumber) % curNode.childNodes.count].dummy) {
			timeDelay = self.settings.scanSpeed.rawValue
		}
        delay(timeDelay) {
            //    we will unhighlight the previously highlighted subtree iff the curNode is
            //    not a leaf node and is not a dummy node
            if self.curNode.childNodes.count != 0 {
                previousCurNode.unHighlightSubTree()
            }
           
            //    check if the cur node has changed
            if !self.curNodeUpdated {
                if self.childNumber == self.curNode.childNodes.count - 1 {
                    //    i.e. we had just now highlighted the last child node of curNode
                    self.childNumber = 0
                } else {
                    self.childNumber += 1
                }
            } else {
                self.curNodeUpdated = false
            }
            
            if self.curNode.childNodes.count != 0 {
                if (self.curNode.childNodes[0] as? ButtonNode)?.dummy == true {
                      self.curNode=self.buttonTree.rootNode!
                }
                //    i.e. we have not yet reached a leaf node while scanning
                self.selectSubTree()
            }
            
            if (self.curNode as? ButtonNode)?.dummy == true {
                self.curNode=self.buttonTree.rootNode!
            }
        }
    }
    
    /* ensures a time delay for executing a block of code */
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func getRootNode() -> Node? {
        return buttonTree.rootNode
    }
    
    func makeSelection() -> String? {
        //    select a subtree from the current subtree stored in curNode
        if self.curNode.childNodes.count > 0 {
            //    i.e. we have not yet reached a leafnode
            self.curNode = curNode.childNodes[childNumber]
            self.childNumber = 0
            self.curNodeUpdated = true
            if curNode.childNodes.count == 0 {
                let choice = (curNode as? ButtonNode)?.button.title(for: .normal)
                self.curNode = (self.getRootNode())!
                return choice
            }
        }
        return nil
    }
	
	/*
	*	takes as input an array of phrases which needs to be filled into the grid structure
	*	the assumption is that the input array size exactly matches the grid size
	*/
	func fillTouchGrid(phrases: [String]) {
		let (rows, cols) = settings.getGridSize()
		let type = settings.scanType
		switch(type) {
		case .ROW_COLUMN:
			for i in 0...(rows - 1) {
				for j in 0...(cols - 1) {
					let buttonNode = self.getRootNode()?.childNodes[i].childNodes[j]
					(buttonNode as? ButtonNode)?.button.setTitle(phrases[i * cols + j], for: .normal)
					self.setDummy(node: buttonNode!)
				}
				self.setDummy(node: (self.getRootNode()?.childNodes[i])!)
			}
			break
		case .BINARY_TREE:
			break
		case .LINEAR:
			for i in 0...(rows * cols - 1) {
				let buttonNode = self.getRootNode()?.childNodes[i]
				(buttonNode as? ButtonNode)?.button.setTitle(phrases[i], for: .normal)
				self.setDummy(node: buttonNode!)
			}
		}
	}
	
	/*
	* 	sets the dummy variable for input node
	*	if input node is a leaf node (i.e. a button node), check if title is "---"
	*	if input node is a non-leaf node check if all its chidren are dummy nodes
	*/
	func setDummy(node: Node) {
		if (((node as? ButtonNode)) != nil) {	//	i.e. the node is a button node
			if ((node as? ButtonNode)?.button.title(for: .normal) == "---") {
				(node as? ButtonNode)?.dummy = true
			}
			else {
			(node as? ButtonNode)?.dummy = false
			}
		}
		else {	//	i.e. input node is an intermediary node (non-leaf)
			node.dummy = true
			for index in 0...(node.childNodes.count - 1) {
				if (node.childNodes[index].dummy == false) {
					node.dummy = false
					break
				}
			}
		}
	}
	
	/*
	*	scanning restarts from the beginning where no cell is selected yet
	*	update the curNode and childNumber to root and 0 respectively
	*	function also unhighlights the entire grid structure
	*/
	func resetTouchGrid() {
		curNode = self.getRootNode()!
		childNumber = 0
		curNode.unHighlightSubTree()
	}
}
