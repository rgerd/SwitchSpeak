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
class ButtonNode: Node {
    var button:UIButton = UIButton(type: UIButtonType.custom)
    var cardData:VocabCard?
    var gridPosition:(Int, Int)
	
    init(button: UIButton, gridPosition:(Int, Int)) {
		self.button = button
        self.gridPosition = gridPosition
		super.init()
	}
    
    func setCardData(cardData:VocabCard) {
        self.cardData = cardData
        
        self.button.setTitle(cardData.text, for: .normal)
        self.button.backgroundColor = convertColortoUIColor(cardData.color)
        let uhcolor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        self.button.layer.borderColor = uhcolor.cgColor
        self.button.layer.borderWidth = 5
    }
    
    func convertColorToUIColor(color: String) -> UIColor {
        var rValue = UInt8(color[0...1], radix: 16)
        var gValue = UInt8(color[2...3], radix: 16)
        var bValue = UInt8(color[4...5], radix: 16)
        return UIColor(red: rValue/255.0, green: gValue/255.0, blue: bValue/255.0, alpha: 1.0)
    }
	
	override func highlightSubTree() {
        if dummy {
            return
        }
		let uhcolor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
		button.layer.borderColor = uhcolor.cgColor
	}
	
	override func unHighlightSubTree() {
        if dummy {
            return
        }
		let uhcolor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
		button.layer.borderColor = uhcolor.cgColor
	}
   
   
}



