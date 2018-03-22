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
    var touchSelection:TouchSelection?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//	dummy array of phrases for the first grid selection
		let dummyPhrases: [String] = ["1", "2", "3", "4", "5", "6", "7", "8","9","10","11"]
		
        // Eventually '0' here would be replaced by the id of the 'signed-in' user
		self.touchSelection = TouchSelection(userId: GlobalSettings.currentUserId, viewContainer: view, phrases: dummyPhrases)
        touchSelection!.touchGrid!.selectSubTree()
        view.bringSubview(toFront: TapButton)
	}

	@IBAction func TapButton(_ sender: Any) {
        touchSelection!.makeSelection()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    // Control + Command + z = Shake on the device simulator.
    // For now we can use this to make the iPad speak. Later we will need a button.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            SpeechManager.say(phrase: touchSelection!.breadcrumbs.getString(), withVoice: GlobalSettings.getUserSettings().voiceType.rawValue)
        }
    }
}

