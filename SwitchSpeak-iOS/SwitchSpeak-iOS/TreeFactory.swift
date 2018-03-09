//
//  TreeFactory.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit


class TreeFactory{
	
	
	/*
		this function creates a tree for row-column scanning
		given the input rows,cols the function outputs a tree with
		the root node having 'rows' chlidnodes, where each of these nodes
		have 'cols' buttonNodes as children
	*/
	func treeForRowColumnScanning (rows: Int ,cols: Int) -> Tree {
		
		let T = Tree()
		T.treeType = .ROW_COLUMN
		T.size = rows*cols
		
		for i in 1...rows{
			let interNode = Node()	//	non-leaf node
			T.rootNode!.addChild(child: interNode)
			
			for j in 1...cols{
				let button = UIButton()
				//	next we will set the attributes of the button
				button.setTitle("(\(i),\(j))", for: .normal)	//	arbitrary title for now
				button.backgroundColor = UIColor.lightGray
				let uhcolor = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 230.0/255.0, alpha: 1.0)
				button.layer.borderColor = uhcolor.cgColor
				button.layer.borderWidth = 5
				let leafNode = ButtonNode(button: button)
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
	func TreeForCellByCellScanning(rows: Int ,cols: Int) -> Tree{
		
		let T = Tree()
		T.treeType = .LINEAR
		T.size = rows*cols
		
		for i in 1...rows{
			for j in 1...cols{
				let button = UIButton()
				//	next we will set the attributes of the button
				button.setTitle("(\(i),\(j))", for: .normal)	//	arbitrary title for now
				button.backgroundColor = UIColor.lightGray
				let uhcolor = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 230.0/255.0, alpha: 1.0)
				button.layer.borderColor = uhcolor.cgColor
				button.layer.borderWidth = 5
				let leafNode = ButtonNode(button: button)
				T.rootNode!.addChild(child: leafNode)
			}
		}
		return T
	}
	
}




