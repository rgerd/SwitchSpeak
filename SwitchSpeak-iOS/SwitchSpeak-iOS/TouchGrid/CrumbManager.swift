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
        var cardData:VocabCard
        // The UI element holding the string describing the breadcrumb.
        // i.e. "I", "am", etc.
        var label:UILabel
        // scale is used to decide the size of crumb according to the number of crumbs
        var scale:CGFloat
        
        init(_ cardData:VocabCard) {
            self.cardData = cardData
            label = UILabel()
            label.text = cardData.text
            scale = 1
        }
        
        /*
         * Sets the color of the breadcrumb as well as its location on the screen
         * relative to the view containing it. The provided index corresponds
         * to the crumb's index in the stack holding it.
         */
        
        func setLocationAndSize(byIndex index:Int, withWidth width:CGFloat) {
            label.frame = CGRect(x: 10 + CGFloat(index) * width  * scale, y: 10, width: width * scale, height: 40)
        }
        
        func setLocationAndColor(byIndex index:Int, withWidth width:CGFloat) {
            setLocationAndSize(byIndex:index, withWidth: width)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = self.cardData.color.getDarker().getDarker()
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
    
    private var crumbWidth: CGFloat
  
    /* setting a threshold for overflowing, once the number of crumbs exceeds the threshold, the size of crumb will depend on the the number of crumbs and behaves like shrinking*/
    private var threshold : Int
    
    private var size_rate : CGFloat  // size_rate = crumbwidth/ screenwidth
    
    init() {
        self.items = []
        self.size_rate = 0.2 // the initial crumb width size is set to be one fifth of the width of screen
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        self.crumbWidth = size_rate * screenWidth
        self.threshold = Int(screenWidth / self.crumbWidth) - 1
    }
    /* This function reset the size of crumb. If the number of crumbs is no more than the threshold, then the size width of crumb will be 1/5 of screen's width. Once the number of crumbs exceed threshold, then the width will be adjusted according to the number of crumbs.
     This function should be called once the number of crumbs changes
 */
    func resetSize(){
        let spokenItems:[Crumb] = getSpokenItems()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        if spokenItems.count > threshold {
            self.crumbWidth = screenWidth / CGFloat(items.count + 1)
            var index:Int = 0
            for item in spokenItems {
                item.setLocationAndSize(byIndex: index, withWidth:self.crumbWidth)
                index += 1
            }
        }
        else {
            crumbWidth = size_rate * screenWidth
            var index:Int = 0
            for item in spokenItems {
                item.setLocationAndSize(byIndex: index, withWidth:self.crumbWidth)
                index += 1
            }
        }
    }
    
    /*
     * Removes a breadcrumb.
	 * add remove the breadcrum from the view as well
     */
    func pop() -> VocabCard? {
		if items.count > 0 {	//	i.e. the stack is not empty
            let lastItem:Crumb = items.removeLast()
			lastItem.label.removeFromSuperview()
            resetSize()
            return lastItem.cardData
		}
        return nil
    }
	
	/*
	*	remove all the breadcrumbs
	*/
	func emptyCrumbStack() {
		while (self.getString() != "") {		//	pop all the elements in the breadcrums stack
			let _ = self.pop()
		}
	}
    
    /*
     * Pushes a breadcrumb referencing [buttonNode] to the stack.
     */
    func push(buttonNode:ButtonNode) {
        let newCrumb = Crumb(buttonNode.cardData!)
        items.append(newCrumb)
        resetSize()
        let spokenItems:[Crumb] = getSpokenItems()
        if newCrumb.cardData.voice {
            newCrumb.setLocationAndColor(byIndex: spokenItems.count - 1, withWidth: self.crumbWidth)
        }
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
        for item in getSpokenItems() {
            fullString += item.label.text! + " "
        }
        return fullString
    }
    
    private func getSpokenItems() -> [Crumb] {
        return items.filter { $0.cardData.voice }
    }
}
