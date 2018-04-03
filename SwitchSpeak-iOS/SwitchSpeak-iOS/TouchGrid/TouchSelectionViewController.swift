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
        
        self.touchSelection = TouchSelection(breadcrumbContainer: breadcrumbContainer, gridContainer: (switchButton as UIView))
        
        lastSettings = GlobalSettings.getUserSettings()
	}

	@IBAction func tapSwitch(_ sender: Any) {
        touchSelection!.makeSelection()
	}
    
    func registerSettingsUpdate() {
        let newSettings:UserSettings = GlobalSettings.getUserSettings()

        var shouldRebuildGrid:Bool = false
        shouldRebuildGrid = shouldRebuildGrid || lastSettings!.gridSize != newSettings.gridSize
        shouldRebuildGrid = shouldRebuildGrid || lastSettings!.vocabLevel != newSettings.vocabLevel
        shouldRebuildGrid = shouldRebuildGrid || lastSettings!.scanType != newSettings.scanType
        shouldRebuildGrid = shouldRebuildGrid || lastSettings!.fontSize != newSettings.fontSize
        shouldRebuildGrid = shouldRebuildGrid || lastSettings!.scanSpeed != newSettings.scanSpeed
        
        if shouldRebuildGrid {
            touchSelection!.touchGrid!.buildButtonTree()
            touchSelection!.refillGrid(withoutPaging: true)
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

