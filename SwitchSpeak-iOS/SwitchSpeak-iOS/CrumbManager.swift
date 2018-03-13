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
    private struct Crumb {
        var view : UILabel
        
        init(content : String) {
            view = UILabel()
            view.text = content
        }
        
        func setLocationAndColor(byIndex index:Int) {
            view.frame = CGRect(x: 10 + (index % 5) * 80, y: 40 * (index / 5 + 1), width: 80, height: 40)
            view.textAlignment = .center
            view.textColor = UIColor.white
            view.backgroundColor = [UIColor.darkGray, UIColor.lightGray][index % 2]
        }
        
        func attachToView(_ view:UIView) {
            if self.view.superview == view {
                return
            }
            view.addSubview(self.view)
        }
    }
    
    private var items: [Crumb]
    
    init() {
        self.items = []
    }
    
    func pop() {
        items.removeLast()
    }
    
    func push(string : String) {
        let newCrumb = Crumb(content: string)
        items.append(newCrumb)
        newCrumb.setLocationAndColor(byIndex: items.count - 1)
    }
    
    func updateSubView(insideView view:UIView) {
        for item in items {
            item.attachToView(view)
        }
    }
}
