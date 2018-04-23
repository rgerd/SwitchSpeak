//
//  EditButtons.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 4/11/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import UIKit

class ButtonEditView: UIView {
    var buttonNode:ButtonNode?
    private var blurEffectView:UIVisualEffectView
    private let framePadding:CGFloat = 10
    private let uiGridSize:CGFloat = 3 // Note this has nothing to do with the switch grid. Just for internal visual spacing.
    private var buttonSize:CGFloat
    private var swapButton:UIButton?
    var swapping:Bool = false {
        didSet {
            if swapping {
                swapButton!.backgroundColor = UIColor.white
                swapButton!.setTitleColor(UIColor.black, for: .normal)
            } else {
                swapButton!.backgroundColor = nil
                swapButton!.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    convenience init(buttonNode:ButtonNode, containerView:UIView) {
        self.init(frame: buttonNode.button.frame)
        
        self.buttonNode = buttonNode
        
        if(buttonNode.cardData!.type == .category) {
            let stepButton:UIButton = constructButton(withTitle: "Step", size: buttonSize)
            stepButton.frame = CGRect(x: framePadding, y: frame.height - framePadding - buttonSize, width: buttonSize, height: buttonSize)
            stepButton.tag = 2
            
            blurEffectView.contentView.addSubview(stepButton)
        }
        
        containerView.addSubview(self)
        containerView.bringSubview(toFront: self)
    }
    
    override init(frame:CGRect) {
        blurEffectView = UIVisualEffectView()
        swapping = false
        
        let minFrameDim:CGFloat = (frame.width < frame.height) ? frame.width : frame.height
        buttonSize = (minFrameDim - framePadding * 2) / uiGridSize
        
        super.init(frame: frame)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 10 // To match ButtonNode
        blurEffectView.clipsToBounds = true
        
        let editButton:UIButton = constructButton(withTitle: "Edit", size: buttonSize)
        editButton.frame = CGRect(x: framePadding, y: framePadding, width: buttonSize, height: buttonSize)
        editButton.tag = 0
        
        swapButton = constructButton(withTitle: "Swap", size: buttonSize)
        swapButton!.frame = CGRect(x: frame.width - framePadding - buttonSize, y: framePadding, width: buttonSize, height: buttonSize)
        swapButton!.tag = 1
        
        blurEffectView.contentView.addSubview(editButton)
        blurEffectView.contentView.addSubview(swapButton!)
        
        self.addSubview(blurEffectView)
    }
    
    private func constructButton(withTitle title:String, size:CGFloat) -> UIButton {
        let button:UIButton = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        
        button.layer.cornerRadius = 0.5 * size
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        
        button.addTarget(self, action: #selector(touchButton), for: .touchDown)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        return button
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.4, animations: {
            self.blurEffectView.effect = UIBlurEffect(style: .dark)
        })
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.15, animations: {
            self.blurEffectView.effect = nil
        }, completion: { (finished:Bool) in
            if finished {
                self.removeFromSuperview()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchSelectionUI.getTouchGrid().setButtonBeingEdited(nil)
    }
    
    @objc func touchButton(_ sender:UIButton) {
        sender.alpha = 0.5;
    }
    
    @objc func tapButton(_ sender:UIButton) {
        sender.alpha = 1.0;
        switch sender.tag {
        case 0: // Edit
            let alert = UIAlertController(title: "Coming soon", message: "This feature is under construction!", preferredStyle: .alert)
            TouchSelectionUI.getViewController().present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
            break
        case 1: // Swap
            swapping = !swapping
            break
        case 2: // Step
            TouchSelectionUI.getTouchSelection().setScreenId(buttonNode!.cardId)
            break
        default:
            fatalError("Somehow a button was tapped with an incorrect tag.")
            break
        }
    }
    
    // Sticking this at the bottom since we need it but we don't use it.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
