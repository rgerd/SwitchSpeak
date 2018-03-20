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
        // scale is used to decide the size of crumb according to the number of crumbs
        var scale:CGFloat
        
        init(content:String) {
            label = UILabel()
            label.text = content
            scale = 1
        }
        
        /*
         * Sets the color of the breadcrumb as well as its location on the screen
         * relative to the view containing it. The provided index corresponds
         * to the crumb's index in the stack holding it.
         */
        
        func setLocationAndSize(byIndex index:Int, withWidth width:CGFloat) {
            label.frame = CGRect(x: 10 + CGFloat(index) * width  * scale, y: 40, width: width * scale, height: 40)
        }
        
        func setLocationAndColor(byIndex ind:Int, withWidth width:CGFloat) {
            setLocationAndSize(byIndex:ind, withWidth: width)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = [UIColor.darkGray, UIColor.lightGray][ind % 2]
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
  
    /* setting a threshold for overflowaing, once the number of crumbs exceeds the threshold, the size of crumb will depend on the the number of crumbs and behives like shrinking*/
    private var threshold : Int
    
    private var size_rate : CGFloat  // size_rate = crumbwidth/ screenwidth
    
    init() {
        self.items = []
        self.size_rate = 0.2 // the initial crumwidth size is set to be one fifth of the width of screen
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        self.crumbWidth = size_rate * screenWidth
        self.threshold = Int(screenWidth / self.crumbWidth) - 1
    }
    
    /*
     * Removes a breadcrumb.
     */
    func pop() {
        items.removeLast()
    }
    
    /*
     * Pushes a breadcrumb containing [string] to the stack.
     */
    func push(string:String) {
        let newCrumb = Crumb(content: string)
        items.append(newCrumb)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if items.count > threshold {
            self.crumbWidth = screenWidth / CGFloat(items.count + 1)
            var ind:Int = 0
            for item in items {
                item.setLocationAndSize(byIndex: ind, withWidth:self.crumbWidth )
                ind = ind + 1
            }
        }
        newCrumb.setLocationAndColor(byIndex: items.count - 1, withWidth: self.crumbWidth)
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
