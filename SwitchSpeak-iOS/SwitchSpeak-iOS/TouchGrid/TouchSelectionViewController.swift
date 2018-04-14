//
//  TouchSelectionViewController.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/5/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//
import UIKit

class TouchSelectionViewController: UIViewController {
    // This is an example of a singleton pattern.
    // We know there will always be exactly one instance of this object at any given moment, and referencing it is very useful for accessing different parts of the main UI, so we hold on to a single global variable to it for convenience throughout the program.
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
	
	@IBAction func toggleEditingMode(_ sender: Any) {
        let touchGrid:TouchGrid = touchSelection!.touchGrid!
		if touchGrid.editing {
			touchGrid.exitEditMode()
		} else {
			touchGrid.enterEditMode()
		}
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

    static func bringSwitchButtonToFront() {
        sharedInstance!.view.bringSubview(toFront: sharedInstance!.switchButton)
    }
}

