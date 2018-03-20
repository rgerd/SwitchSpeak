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
        
        self.buttonTree = TreeFactory.buildTree(type: settings.scanType, size: settings.getGridSize())
        
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
        
        delay(self.settings.scanSpeed.rawValue) {
            //    we will unhighlight the previously highlighted subtree iff the curNode is
            //    not a leaf node
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
                //    i.e. we have not yet reached a leaf node while scanning
                self.selectSubTree()
            }
        }
    }
    
    //    ensures a time delay for executing a block of code
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
}
