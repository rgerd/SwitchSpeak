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
        self.touchGrid = TouchGrid(userId: GlobalSettings.currentUserId, viewContainer: view)
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
    
    // Control + Command + z = Shake on the device simulator.
    // For now we can use this to make the iPad speak. Later we will need a button.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            SpeechManager.say(phrase: breadcrumbs.getString(), withVoice: GlobalSettings.getUserSettings().voiceType.rawValue)
        }
    }
}

