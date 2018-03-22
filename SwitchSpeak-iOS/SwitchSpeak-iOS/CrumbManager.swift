//
//  CrumbManager.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 3/13/18.
//  Original code by Ning Luo.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit

class CrumbStack {
    /*
     * A private structure to handle the storage and rendering of breadcrumbs.
     */
    private struct Crumb {
        // The UI element holding the string describing the breadcrumb.
        // i.e. "I", "am", etc.
        var label:UILabel
        
        init(content:String) {
            label = UILabel()
            label.text = content
        }
        
        /*
         * Sets the color of the breadcrumb as well as its location on the screen
         * relative to the view containing it. The provided index corresponds
         * to the crumb's index in the stack holding it.
         */
        func setLocationAndColor(byIndex index:Int) {
            label.frame = CGRect(x: 10 + (index % 5) * 80, y: 40 * (index / 5 + 1), width: 80, height: 40)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = [UIColor.darkGray, UIColor.lightGray][index % 2]
        }
        
        /*
         * Attaches this crumb's label to a view on the screen.
         * The containerView is either the root view or an
         * empty view designating the desired position / size
         * of the breadcrumb view.
         */
        func attachToView(_ containerView:UIView) {
            // Don't attach the breadcrumb if it is already attached
            if self.label.superview == containerView {
                return
            }
            containerView.addSubview(self.label)
        }
    }
    
    // The stack holding the breadcrumbs.
    private var items: [Crumb]
    
    init() {
        self.items = []
    }
    
    /*
     * Removes a breadcrumb.
	 * add remove the breadcrum from the view as well
     */
    func pop() {
		if (self.getString() != "") {	//	i.e. the stack is not empty
			items.removeLast().label.removeFromSuperview()
		}
		
    }
	
	/*
	*	remove all the breadcrumbs
	*/
	func emptyCrumbStack() {
		while (self.getString() != "") {		//	pop all the elements in the breadcrums stack
			self.pop()
		}
	}
    
    /*
     * Pushes a breadcrumb containing [string] to the stack.
     */
    func push(string:String) {
        let newCrumb = Crumb(content: string)
        items.append(newCrumb)
        newCrumb.setLocationAndColor(byIndex: items.count - 1)
    }
    
    /*
     * Updates the breadcrumb UI
     */
    func updateSubViews(insideView view:UIView) {
        for item in items {
            item.attachToView(view)
        }
    }
    
    /*
     * Concatenates the contents of the breadcrumbs in this stack
     * into a single string. This can be used with the speech
     * synthesizer to utter a sentence built by the user.
     */
    func getString() -> String {
        var fullString:String = ""
        for item in items {
            fullString += item.label.text! + " "
        }
        return fullString
    }
}
