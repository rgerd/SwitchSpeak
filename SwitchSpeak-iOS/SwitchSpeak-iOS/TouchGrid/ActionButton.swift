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
	case home = "Home"			//	restart the sentence formation process
	case next = "Next"			//	go to the next grid i.e. the next set of phrases
	case done = "Done"			//	sentence is formed
}

class ButtonAction {
	
	static func doOops(touchSelection: TouchSelection) {
		//	go to the previous set of phrases for selection
		//	update phrases array
		let phrases: [String] = ["1", "2", "3", "4", "5", "6", "7", "8","9","10","11"]		//	dummy phrases
		touchSelection.breadcrumbs.pop()
		touchSelection.updatePhrases(phrases: phrases)		//	update set of phrases for the next selection
	}
	
	static func doHome(touchSelection: TouchSelection) {
		//	remove all the breadcrumbs and resart sentence formation
		let phrases: [String] = ["1", "2", "3", "4", "5", "6", "7", "8","9","10","11"]		//	dummy phrases
		touchSelection.breadcrumbs.emptyCrumbStack()
		touchSelection.updatePhrases(phrases: phrases)		//	update set of phrases for the next selection
	}
	
	static func doNext(touchSelection: TouchSelection) {
		//	i.e. go to the next page of the same set of phrases
		touchSelection.refillGrid()
	}
	
	static func doDone(touchSelection: TouchSelection) {
		//	i.e. the sentence is selected
		//	add other code including speech output related code
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
