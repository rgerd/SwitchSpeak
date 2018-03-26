//
//  TouchSelectionViewController.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/5/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//
import UIKit

class TouchSelectionViewController: UIViewController {
    static var sharedInstance:TouchSelectionViewController?
	@IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var breadcrumbContainer: UIView!
    var touchSelection:TouchSelection?
    var lastSettings:UserSettings?
    
	override func viewDidLoad() {
		super.viewDidLoad()
        TouchSelectionViewController.sharedInstance = self
		//	dummy array of phrases for the first grid selection
		let dummyPhrases: [String] = ["1", "2", "3", "4", "5", "6", "7", "8","9","10","11"]
		
        self.touchSelection = TouchSelection(breadcrumbContainer: breadcrumbContainer, gridContainer: (switchButton as UIView), phrases: dummyPhrases)
        touchSelection!.touchGrid!.selectSubTree()
        
        lastSettings = GlobalSettings.getUserSettings()
	}

	@IBAction func tapSwitch(_ sender: Any) {
        touchSelection!.makeSelection()
	}
    
    func registerSettingsUpdate() {
        let newSettings:UserSettings = GlobalSettings.getUserSettings()
        if lastSettings!.gridSize != newSettings.gridSize || lastSettings!.vocabLevel != newSettings.vocabLevel || lastSettings?.scanType != newSettings.scanType {
            touchSelection!.touchGrid!.buildButtonTree()
            touchSelection!.refillGrid()
        }
        lastSettings = newSettings
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    static func bringSwitchButtonToFront() {
        sharedInstance!.view.bringSubview(toFront: sharedInstance!.switchButton)
    }
}

