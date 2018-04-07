//
//  Tree.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit

class Tree {
	var rootNode: Node?
	var treeType: ScanType?
	var size: Int?  //  The number of button nodes present in the tree
	
	init(root: Node) {
		self.rootNode = root
		self.treeType = nil
		self.size = 0
	}
	
	init() {
		let root = Node()
		self.rootNode = root
		self.treeType = nil
		self.size = 0
	}
    
	/*
		Input is the grid dimensions of the view, the width and height of the screen, the height of the top bar, and the max button dimensions
		In this function we resize each button in the tree so as to fit it entirely in the view
	*/
    func setUIDimensionsForTree (gridSize:(Int, Int), gridContainer:UIView, maxButtonSize:(Int, Int)) {
        let (numRows, numCols) = gridSize
        let containerWidth = Int(UIScreen.main.bounds.width)
        let containerTop = Int(gridContainer.frame.minY)
        let containerHeight = Int(UIScreen.main.bounds.height) - containerTop
        
		//	first we compute the size of buttons to be placed in view
        let buttonSize = Tree.computeButtonSize(gridSize: gridSize, containerSize: (containerWidth, containerHeight), maxButtonSize: maxButtonSize)
		
        let colFullWidth = buttonSize.buttonWidth + buttonSize.colGap
        let rowFullHeight = buttonSize.buttonHeight + buttonSize.rowGap
		
        //	check if the tree has the appropriate dimensions and is linear scan type (i.e. a depth 2 tree)
		if (self.size == numRows * numCols && self.treeType == .LINEAR) {
			for i in 0...(numRows - 1) {
				for j in 0...(numCols - 1) {
					(self.rootNode?.childNodes[numCols * i + j] as? ButtonNode)?.button.frame = CGRect(x: colFullWidth * j + buttonSize.colGap, y: containerTop + rowFullHeight * i, width: buttonSize.buttonWidth, height: buttonSize.buttonHeight)
				}
			}
		}
		
		if (self.rootNode!.childNodes.count == numRows && self.treeType == .ROW_COLUMN) {
			var checkDimensions = true	//	is set to false if dimensions of the tree are not in accordance with a row-col scan tree
			for childNode in self.rootNode!.childNodes {
				if (childNode.childNodes.count != numCols) {
						checkDimensions = false
				}
			}
			//	if tree is of row-column scan type of dimensions rowXcol
			if (checkDimensions) {
				for i in 0...(numRows - 1) {
					let curNode = self.rootNode!.childNodes[i]
					for j in 0...(numCols - 1) {
						(curNode.childNodes[j] as? ButtonNode)?.button.frame = CGRect(x: colFullWidth * j + buttonSize.colGap, y: containerTop + rowFullHeight * i, width: buttonSize.buttonWidth, height: buttonSize.buttonHeight)
					}
				}
			}
			
		}
	}
    
    /*
     Input is the grid dimensions, the width and height of the screen, the max button dimensions
     It outputs the width, height of the button along with the row gap and column gap that seperates these buttons
     */
    class func computeButtonSize  (gridSize: (Int, Int), containerSize: (Int, Int), maxButtonSize: (Int, Int)) -> (buttonHeight: Int, buttonWidth: Int, colGap: Int, rowGap: Int) {
        let (numRows, numCols) = gridSize
        let (containerWidth, containerHeight) = containerSize
        let (maxButtonWidth, maxButtonHeight) = maxButtonSize
        
        var colGap = 5, rowGap = 5    //    this would be the gap between successive buttons on the view
        //    5 is  magic number above and it correponds to the minimum gap between buttons
        var buttonHeight = (containerHeight - rowGap * (numRows + 1)) / numRows
        var buttonWidth = (containerWidth - colGap * (numCols + 1)) / numCols
        
        if (buttonHeight > maxButtonHeight) {
            buttonHeight = maxButtonHeight
            rowGap = (containerHeight - (numRows * buttonHeight)) / (numRows + 1)
        }
        if (buttonWidth > maxButtonWidth) {
            buttonWidth = maxButtonWidth
            colGap = (containerWidth - (numCols * buttonWidth)) / (numCols + 1)
        }
        return (buttonHeight, buttonWidth, colGap, rowGap)
    }
}




