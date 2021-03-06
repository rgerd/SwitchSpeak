//
//  TreeFactory.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit

class TreeFactory {
    /*
        returns a tree corresponding to the provided scan type and
        grid size. this function is especially useful when you just
        want to build a tree from user settings.
        dummyNum is the number of dummy buttons in this tree
     */
    class func buildTree(type:ScanType, size:(Int, Int), dummyNum:Int) -> Tree {
        let (numRows, numCols) = size
        switch(type) {
        case .NO_SCAN:
            // Doesn't matter what we use here, as long as we have some tree.
            return treeForCellByCellScanning(rows: numRows, cols: numCols, dummyNum: dummyNum)
        case .ROW_COLUMN:
            return treeForRowColumnScanning(rows: numRows, cols: numCols, dummyNum: dummyNum)
        case .LINEAR:
            return treeForCellByCellScanning(rows: numRows, cols: numCols, dummyNum: dummyNum)
        }
    }
    
	/*
		this function creates a tree for row-column scanning
		given the input rows,cols the function outputs a tree with
		the root node having 'rows' chlidnodes, where each of these nodes
		have 'cols' buttonNodes as children
     
        dummyNum is the number of dummy buttons in this tree
	*/
    class func treeForRowColumnScanning (rows: Int, cols: Int, dummyNum: Int) -> Tree {
		let T = Tree()
		T.treeType = .ROW_COLUMN
		T.size = rows * cols
        // compute the positions of dummy buttons according to the number of dummy buttons
        // buttons
        let dummyCol = cols - dummyNum % cols
        let dummyRow = rows - dummyNum / cols
		
		for i in 1...rows {
			let interNode = Node()	//	non-leaf node
			T.rootNode!.addChild(child: interNode)
			
			for j in 1...cols {
                let leafNode = ButtonNode(button: UIButton(), gridPosition: (i, j))
				leafNode.button.tag = (i - 1) * cols + j;	//	tag goes from 1 to rows*cols
                if ((i > dummyRow) || (i == dummyRow && j > dummyCol))  {
                   leafNode.dummy = true
                }
				interNode.addChild(child: leafNode)
			}
		}
		return T
	}
	
	/*
		This function returns a tree to implement cell by cell scanning
		Given inputs n and m, the output is a tree
		with a root node having n*m nodes
	*/
	class func treeForCellByCellScanning(rows: Int, cols: Int, dummyNum: Int) -> Tree {
		let T = Tree()
		T.treeType = .LINEAR
		T.size = rows * cols
        let dummyCol = cols - dummyNum % cols
        let dummyRow = rows - dummyNum / cols
		
		for i in 1...rows {
			for j in 1...cols {
                let leafNode = ButtonNode(button: UIButton(), gridPosition: (i, j))
				leafNode.button.tag = (i - 1) * cols + j;	//	tag goes from 1 to rows*cols
                if ((i > dummyRow) || (i == dummyRow && j > dummyCol))  {
                    leafNode.dummy = true
                }
				T.rootNode!.addChild(child: leafNode)
			}
		}
		return T
	}
}




