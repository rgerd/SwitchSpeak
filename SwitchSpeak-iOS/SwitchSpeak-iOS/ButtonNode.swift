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
		
		let uhcolor = UIColor(red: 200.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
		button.layer.borderColor = uhcolor.cgColor
	}
	
	override func unHighlightSubTree(){
		let uhcolor = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 230.0/255.0, alpha: 1.0)
		button.layer.borderColor = uhcolor.cgColor
	}
}



