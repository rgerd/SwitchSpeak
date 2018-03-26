//
//  ButtonAction.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 3/22/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation


enum ActionButton : String {
	case oops = "Oops"			//	remove the previously selected phrase and restart from that spot
	case home = "Home Screen"	//	restart the sentence formation process
	case next = "Next"			//	go to the next grid i.e. the next set of phrases
	case done = "Speak"			//	sentence is formed
}

class ButtonAction {
	
	static func doOops(touchSelection: TouchSelection) {
        guard let lastButton:ButtonNode = touchSelection.breadcrumbs.pop() else {
            return
        }
        
        if lastButton.cardData!.type == .category {
            touchSelection.setScreenId(lastButton.cardData!.parentid)   //    update set of phrases for the next selection
        }
	}
	
	static func doHome(touchSelection: TouchSelection) {
		touchSelection.breadcrumbs.emptyCrumbStack()
		touchSelection.setScreenId(0)
	}
	
	static func doNext(touchSelection: TouchSelection) {
		//	i.e. go to the next page of the same set of phrases
		touchSelection.refillGrid()
	}
	
	static func doDone(touchSelection: TouchSelection) {
		//	i.e. the sentence is selected
		//	add other code including speech output related code
        SpeechManager.say(phrase: touchSelection.breadcrumbs.getString(), withVoice: GlobalSettings.getUserSettings().voiceType.rawValue)
	}
	
	static func callAction(actionButton: ActionButton, touchSelection: TouchSelection) {
		switch (actionButton) {
		case .oops:
			doOops(touchSelection: touchSelection)
		case .home:
			doHome(touchSelection: touchSelection)
		case .next:
			doNext(touchSelection: touchSelection)
		case .done:
			doDone(touchSelection: touchSelection)
		}
	}
	
}
