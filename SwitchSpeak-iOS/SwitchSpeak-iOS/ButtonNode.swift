//
//  ButtonNode.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit


/*
	a ButtonNode would always be a leaf node in the 'Tree' data structure
*/
class ButtonNode: Node{
	var button = UIButton(type: UIButtonType.custom)
	
	init(button: UIButton) {
		self.button = button
		super.init()
	}
	
	override func highlightSubTree(){
		//	for now a button is highlighted with a change in background color
		self.button.backgroundColor = UIColor.blue
	}
	
	override func unHighlightSubTree(){
		self.button.backgroundColor = UIColor.lightGray
	}
}



