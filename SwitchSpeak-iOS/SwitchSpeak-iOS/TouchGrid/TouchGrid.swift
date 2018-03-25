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
    // The result of the scanning procedure will be stored in curNode and childNumber variables
    var curNode = Node()                // The node in the tree we are currently scanning
    var childNumber: Int = 0            // The index of the highlighted child of curNode
    var curNodeUpdated: Bool = false    // This is set to true whenever curNode is updated
    
    private var gridContainer:UIView!   // The UIView that contains the grid container
    private var buttonTree:Tree!        // The touch grid's underlying button tree
    
    init(gridContainer:UIView) {
        self.gridContainer = gridContainer
        self.buildButtonTree()
    }
    
    /*
     * Builds the button tree and places the buttons on the view.
     * This function will clean any previous button tree.
     * Finally, the switch button is brought in front of the button tree nodes.
     */
    func buildButtonTree() {
        if self.buttonTree != nil {
            self.removeTreeFromView(buttonTree)
        }
        let settings = GlobalSettings.getUserSettings()
        self.buttonTree = TreeFactory.buildTree(type: settings.scanType, size: settings.getGridSize(), dummyNum: 0)
        self.buttonTree.setUIDimensionsForTree(gridSize: settings.getGridSize(), gridContainer: self.gridContainer, maxButtonSize: (200, 200))
        self.addTreeToView(buttonTree)
        self.curNode = buttonTree.rootNode!
        TouchSelectionViewController.bringSwitchButtonToFront()
    }
    
    /*
     * Adds all the buttons present in the leaf nodes of the input tree to the view.
     */
    func addTreeToView(_ T: Tree) {
        addSubTreeToView(T.rootNode!)
    }
    
    /*
     * Removes all the buttons present in the leaf nodes of the input tree from the view.
     */
    func removeTreeFromView(_ T: Tree) {
        removeSubTreeFromView(T.rootNode!)
    }
    
    /*
     * Adds all the buttons present in the leaf nodes of the tree rooted at node to the view.
     */
    func addSubTreeToView(_ node: Node) {
        // If node is of an object of class ButtonNode (i.e. it is a leaf node)
        if let curNode = node as? ButtonNode {
            gridContainer.superview!.addSubview(curNode.button)
            return
        }
        
        for childnode in node.childNodes {
            addSubTreeToView(childnode)
        }
    }
    
    /*
     * Removes all the buttons present in the leaf nodes of the tree rooted at node from the view.
     */
    func removeSubTreeFromView(_ node: Node) {
        // if node is of an object of class ButtonNode (i.e. it is a leaf node)
        if let curNode = node as? ButtonNode {
            curNode.button.removeFromSuperview()
            return
        }
        
        for childnode in node.childNodes {
            removeSubTreeFromView(childnode)
        }
    }
    
    /*
     * Highlights the childNumber'th child node of the curNode.
     */
    func selectSubTree() {
        curNode.childNodes[childNumber].highlightSubTree()
        let previousCurNode: Node = curNode
		var timeDelay = 0.0
		if (!curNode.childNodes[childNumber].dummy) {
			timeDelay = GlobalSettings.getUserSettings().scanSpeed.rawValue
		}
        delay(timeDelay) {
            // We will unhighlight the previously highlighted subtree iff the curNode is not a leaf node and is not a dummy node.
            if self.curNode.childNodes.count != 0 {
                previousCurNode.unHighlightSubTree()
            }
           
            // Check if the cur node has changed.
            if !self.curNodeUpdated {
                self.childNumber = (self.childNumber + 1) % self.curNode.childNodes.count
            } else {
                self.curNodeUpdated = false
            }
            
            if self.curNode.childNodes.count != 0 {
                if (self.curNode.childNodes[0] as? ButtonNode)?.dummy == true {
                      self.curNode=self.buttonTree.rootNode!
                }
                // We have not yet reached a leaf node while scanning.
                self.selectSubTree()
            }
            
            if (self.curNode as? ButtonNode)?.dummy == true {
                self.curNode=self.buttonTree.rootNode!
            }
        }
    }
    
    /*
     * Ensures a time delay for executing a block of code.
     */
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    /*
     * Gets the button tree's root node.
     */
    func getRootNode() -> Node? {
        return buttonTree.rootNode
    }
    
    func makeSelection() -> String? {
        // Select a subtree from the current subtree stored in curNode
        if self.curNode.childNodes.count > 0 {
            // We have not yet reached a leafnode
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
	 *	Takes as input an array of phrases which needs to be filled into the grid structure
     *	Assumption: the input array size exactly matches the grid size
	 */
	func fillTouchGrid(phrases: [String]) {
        let settings = GlobalSettings.getUserSettings()
		let (rows, cols) = settings.getGridSize()
		let type = settings.scanType
		switch(type) {
		case .ROW_COLUMN:
			for i in 0...(rows - 1) {
				for j in 0...(cols - 1) {
					let buttonNode = self.getRootNode()?.childNodes[i].childNodes[j]
					(buttonNode as? ButtonNode)?.button.setTitle(phrases[i * cols + j], for: .normal)
					self.determineDummy(node: buttonNode!)
				}
				self.determineDummy(node: (self.getRootNode()?.childNodes[i])!)
			}
			break
		case .BINARY_TREE:
			break
		case .LINEAR:
			for i in 0...(rows * cols - 1) {
				let buttonNode = self.getRootNode()?.childNodes[i]
				(buttonNode as? ButtonNode)?.button.setTitle(phrases[i], for: .normal)
				self.determineDummy(node: buttonNode!)
			}
		}
	}
	
	/*
	 * 	Sets the dummy variable for input node.
	 *	if input node is a leaf node (i.e. a button node), check if title is "---".
	 *	if input node is a non-leaf node check if all its chidren are dummy nodes.
	 */
	func determineDummy(node: Node) {
		if (((node as? ButtonNode)) != nil) {	//	i.e. the node is a button node
			if ((node as? ButtonNode)?.button.title(for: .normal) == "---") {
				(node as? ButtonNode)?.dummy = true
			} else {
                (node as? ButtonNode)?.dummy = false
			}
		} else {	//	i.e. input node is an intermediary node (non-leaf)
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
	 *	Scanning restarts from the beginning where no cell is selected yet.
	 *	Update the curNode and childNumber to root and 0 respectively.
	 *	This also unhighlights the entire grid structure.
	 */
	func resetTouchGrid() {
		curNode = self.getRootNode()!
		childNumber = 0
		curNode.unHighlightSubTree()
	}
}
