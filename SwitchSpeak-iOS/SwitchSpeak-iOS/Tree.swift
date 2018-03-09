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
	var size: Int?			//	contains the number of button nodes present in the tree
	
	init(root: Node){
		self.rootNode = root
		self.treeType = nil
		self.size = 0
	}
	
	init(){
		let root = Node()
		self.rootNode = root
		self.treeType = nil
		self.size = 0
	}
	
	/*
	Intput is the grid dimensions of the view, the width and height of the screen, the height of the top bar, and the max button zie dimensions
	In this function we resize each button in the tree so as to fit it entirely in the view
	*/
	func setFrameSizeForTree (row: Int, col: Int, screenWidth: Int, screenHeight: Int, topBarHeight: Int, maxButtonHeight: Int, maxButtonWidth: Int)
	{
		//	first we compute the size of buttons to be placed in view
		let buttonSize = computeButtonSize(row: row, col: col, width: screenWidth, height: screenHeight-topBarHeight, maxButtonHeight: maxButtonHeight, maxButtonWidth: maxButtonWidth)
		
		if (self.size == row*col && self.treeType == .LINEAR)	//	check if the tree is appropriate dimensions and is linear scan type (a depth 2 tree)
		{
			for i in 0...row-1{
				for j in 0...col-1{
					(self.rootNode?.childNodes[col*i+j] as? ButtonNode)?.button.frame = CGRect(x: (buttonSize.buttonWidth + buttonSize.colGap) * j + buttonSize.colGap, y:  topBarHeight + (buttonSize.buttonHeight + buttonSize.rowGap) * i + buttonSize.rowGap, width: buttonSize.buttonWidth, height: buttonSize.buttonHeight)
				}
			}
		}
	}
}
/*
	Intput is the grid dimensions of the view, the width and height of the screen, the max button dimensions
	It outputs the width, height of the button along with the row gap and column gap that seperates these buttons
*/
func computeButtonSize  (row: Int, col: Int, width: Int, height: Int, maxButtonHeight: Int, maxButtonWidth: Int) -> (buttonHeight: Int, buttonWidth: Int, colGap: Int, rowGap: Int)
	{
		var colGap = 5, rowGap = 5	//	this would be the gap between successive buttons on the view
		//	5 is  magic number above and it correponds to the minimum gap between buttons
		var buttonHeight = ( height - rowGap*(row+1) ) / row
		var buttonWidth = ( width - colGap*(col+1) ) / col
		
		if (buttonHeight > maxButtonHeight)
		{
			buttonHeight = maxButtonHeight
			rowGap = (height - (row * buttonHeight) )/(row+1)
		}
		if (buttonWidth > maxButtonWidth)
		{
			buttonWidth = maxButtonWidth
			colGap = (width - (col * buttonWidth) )/(col+1)
		}
		
		return (buttonHeight, buttonWidth,colGap,rowGap)
	}




