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
    var scanNode = Node()                // The node in the tree we are currently scanning
	var prevScanNode = Node()		//	scanNode during the previous scanning step
    var scanChildIndex: Int = 0            // The index of the highlighted child of scanNode
	var nextScanChildIndex: Int = 0
	weak var scanningTimer: Timer?

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
        self.scanNode = buttonTree.rootNode!
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
	

	func startScanning() {
		let scanSpeed = GlobalSettings.getUserSettings().scanSpeed.rawValue
		scanningTimer = Timer.scheduledTimer(withTimeInterval: scanSpeed, repeats: true) { [weak self] _ in
			self?.selectSubTree()
		}
	}
	
	func stopScanning() {
		scanningTimer?.invalidate()
	}
	
    
    /*
     * Highlights the next child node of the scanNode.
     */
    func selectSubTree() {

		if (scanNode.childNodes.count > 0 && scanNode.countNonDummyChildNodes() > 0) {
			self.prevScanNode.unHighlightSubTree()
			scanChildIndex = nextScanChildIndex
			self.scanNode.childNodes[scanChildIndex].highlightSubTree()
			self.prevScanNode = scanNode
			repeat {		//	repeat until we find a non-dummy node
				nextScanChildIndex = (nextScanChildIndex + 1) % self.scanNode.childNodes.count
			} while (scanNode.childNodes[nextScanChildIndex].dummy)
		}
    }
	
	
    /*
     * Gets the button tree's root node.
     */
    func getRootNode() -> Node? {
        return buttonTree.rootNode
    }
    
    func makeSelection() -> ButtonNode? {
        // Select a subtree from the current subtree stored in scanNode
        if self.scanNode.childNodes.count > 0 {
			self.prevScanNode = scanNode
            self.scanNode = scanNode.childNodes[scanChildIndex]
            self.scanChildIndex = 0
			self.nextScanChildIndex = 0
            if scanNode.childNodes.count == 0 {
                let choice:ButtonNode = (scanNode as? ButtonNode)!
                self.scanNode = (self.getRootNode())!
                return choice
            }
        }
        return nil
    }
	
	/*
	 *	Takes as input an array of phrases which needs to be filled into the grid structure
     *	Assumption: the input array size exactly matches the grid size
	 */
	func fillTouchGrid(cards: [VocabCard]) {
        fillTouchGridSubTree(self.getRootNode()!, cards)
	}
    
    func fillTouchGridSubTree(_ node:Node, _ cards:[VocabCard]) {
        let settings = GlobalSettings.getUserSettings()
        let (_, numCols) = settings.getGridSize()
        
        guard let buttonNode:ButtonNode = node as? ButtonNode else {
            for childnode in node.childNodes {
                fillTouchGridSubTree(childnode, cards)
            }
            determineDummy(node: node)
            return
        }
        let (gridRow, gridCol) = buttonNode.gridPosition
        buttonNode.setCardData(cardData: cards[((gridCol - 1) + (gridRow - 1) * numCols)])
        determineDummy(node: buttonNode)
    }
	
	/*
	 * 	Sets the dummy variable for input node.
	 *	if input node is a leaf node (i.e. a button node), check if title is "---".
	 *	if input node is a non-leaf node check if all its chidren are dummy nodes.
	 */
	func determineDummy(node: Node) {
		if (((node as? ButtonNode)) != nil) {	//	i.e. the node is a button node
			if ((node as? ButtonNode)?.button.title(for: .normal) == "   ") {
				(node as? ButtonNode)?.dummy = true
			} else {
                (node as? ButtonNode)?.dummy = false
			}
        } else { //	i.e. input node is an intermediary node (non-leaf)
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
		self.stopScanning()
		scanNode = self.getRootNode()!
		prevScanNode = self.getRootNode()!
		scanChildIndex = 0
		nextScanChildIndex = 0
		self.startScanning()
	}
}

