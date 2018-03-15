//
//  ViewController.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/5/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var TapButton: UIButton!
	var breadcrumbs = CrumbStack()
    var touchGrid:TouchGrid?
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        // Eventually '0' here would be replaced by the id of the 'signed-in' user
        self.touchGrid = TouchGrid(userId: 0, viewContainer: view)
		touchGrid!.selectSubTree()
        
        view.bringSubview(toFront: TapButton)
	}

	@IBAction func TapButton(_ sender: Any) {
        let choice:String? = touchGrid!.makeSelection()
        
        if(choice == nil) { // If we're still scanning deeper
            return;
        }
        
        breadcrumbs.push(string: choice!)
        breadcrumbs.updateSubViews(insideView: view)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

