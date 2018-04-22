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
    static let highlightBorderWidth:CGFloat = 10.0
    static let highlightColor:CGColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    
    // Tunable parameter for scaling the bottom margin with respect to font size
    static let titleBottomMarginScale:CGFloat = 730.0
    
    var button:UIButton = UIButton(type: .custom)

    var cardData:VocabCard?
    
    var cardId:Int64 {
        if self.cardData == nil {
            return -1
        }
        return self.cardData!.id!
    }
    
    var hidden:Bool {
        get {
            if self.cardData == nil {
                return false
            }
            return self.cardData!.hidden
        }
        set {
            if newValue == hidden {
                return
            }
            self.cardData!.hidden = hidden
            self.button.alpha = newValue ? 0.5 : 1.0
        }
    }
    
    var gridPosition:(Int, Int)
    
    private var editView:ButtonEditView?
    var editSelected:Bool = false {
        didSet {
            if oldValue == editSelected {
                return
            }
            if editSelected {
                self.editView = ButtonEditView(buttonNode: self, containerView: TouchSelectionUI.getMainView())
                self.editView?.fadeIn()
            } else {
                self.editView?.fadeOut()
                self.editView = nil
            }
        }
    }
    func isSwapping() -> Bool {
        return editView!.swapping
    }
	
    init(button: UIButton, gridPosition:(Int, Int)) {
		self.button = button
        self.gridPosition = gridPosition
        super.init()
	}
    
    func setCardData(cardData:VocabCard) {
        self.cardData = cardData
        
        self.button.setTitle(cardData.text, for: .normal)
        self.button.titleLabel!.numberOfLines = 0; // Dynamic number of lines
        self.button.titleLabel!.lineBreakMode = .byWordWrapping;
        
        let fontSize:CGFloat = GlobalSettings.getUserSettings().getFontSize()
        let sizedFont:UIFont = self.button.titleLabel!.font!.withSize(fontSize)
        self.button.titleLabel!.font = sizedFont
        
        if let cardImage:UIImage = UIImage(data:cardData.imagefile) {
            let buttonWidth:CGFloat = self.button.frame.width
            let buttonHeight:CGFloat = self.button.frame.height
            let buttonAR:CGFloat = buttonWidth / buttonHeight // Button Aspect Ratio
            let _buttonAR:CGFloat = 1.0 / buttonAR
            
            let imageBorderTop:CGFloat = 12
            let imageBorderSides:CGFloat = fontSize * 1.2 // Vary image size with font size.
            
            let imageTop:CGFloat = imageBorderTop * _buttonAR
            let imageBottom:CGFloat = (2 * imageBorderSides - imageBorderTop) * _buttonAR // Think about it...
            let imageSides:CGFloat = imageBorderSides * buttonAR
            
            let titleOffs:CGFloat = (self.button.frame.height) - fontSize - (ButtonNode.titleBottomMarginScale / fontSize)
            
            self.button.setImage(cardImage, for: .normal)
            self.button.imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageSides, bottom: imageBottom, right: imageSides)
            
            self.button.titleEdgeInsets = UIEdgeInsets(top: titleOffs, left: -cardImage.size.width, bottom: 0, right: 0)
        }
        
        self.button.backgroundColor = cardData.color
        
        self.button.layer.cornerRadius = 10
        self.button.layer.borderColor = ButtonNode.highlightColor
        self.button.layer.borderWidth = 0
        self.button.layer.shadowOpacity = 0.0
        
        self.button.addTarget(self, action:#selector(select), for: .touchUpInside)
        
        self.hidden = cardData.hidden
        
        self.button.layoutIfNeeded()
        
        // When this button node is loaded, if the touchgrid is editing this card id, reflect its selection in the UI.
        if(TouchSelectionUI.hasTouchSelection()) {
            let touchGrid:TouchGrid = TouchSelectionUI.getTouchGrid()
            let currentEditButton:ButtonNode? = touchGrid.getButtonBeingEdited()
            if currentEditButton != nil && currentEditButton!.cardId == self.cardId {
                let swapping:Bool = currentEditButton!.isSwapping()
                touchGrid.setButtonBeingEdited(self)
                self.editView!.swapping = swapping
            }
        }
    }
    
	override func highlightSubTree() {
        if dummy {
            return
        }
		button.layer.borderWidth = ButtonNode.highlightBorderWidth
	}
	
	override func unHighlightSubTree() {
        if dummy {
            return
        }
		button.layer.borderWidth = 0
	}
    
    @objc func select() {
        switch(self.cardData!.type) {
        case .empty:
            return
        case .action:
            self.callAction()
            return
        default:
            self.selectCard()
            return
        }
    }
    
    private func selectCard() {
        let touchGrid:TouchGrid = TouchSelectionUI.getTouchGrid()
        
        if touchGrid.editing {
			// Swapping
			let currentEditButton:ButtonNode? = touchGrid.getButtonBeingEdited()
            if currentEditButton != nil && currentEditButton?.editView?.swapping == true {
                var card = (currentEditButton?.cardData)!
                let settings:UserSettings = GlobalSettings.getUserSettings()
                VocabCardDB.shared!.swapCards(&card, &self.cardData!, inTable: settings.tableName)
                swap(&card, &self.cardData!)
                touchGrid.setButtonBeingEdited(nil)
                TouchSelectionUI.getTouchSelection().refillGrid(withoutPaging: true)

                return
            }
            touchGrid.setButtonBeingEdited(self)
            return
        }
        
        TouchSelectionUI.getTouchSelection().selectCard(self.cardData!)
    }
	
    
    private func callAction() {
        if(self.cardData!.type != .action) {
            return
        }
        
        guard let actionButton = ActionButton(rawValue: self.cardData!.text) else {
            return
        }
        
        ButtonAction.callAction(actionButton: actionButton, touchSelection: TouchSelectionUI.getTouchSelection())
    }
    
    deinit {
        button.removeFromSuperview()
        if editView != nil {
            editView?.removeFromSuperview()
        }
    }
}




