//
//  TouchSelection.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 3/21/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit

class TouchSelection {

	var userId:Int!
	var settings:UserSettings!
	var touchGrid:TouchGrid?
	var breadcrumbs = CrumbStack()
	var phrases:[String]
	var gridSize:Int
	var index:Int		//	keeps track of which set of phrases from the array 'phrases' we are currently printing on the gird
	
	private var viewContainer:UIView!
	
	
	init(userId:Int, viewContainer:UIView, phrases: [String]) {
		self.userId = userId
		self.settings = GlobalSettings.userSettings[userId]
		self.viewContainer = viewContainer
		self.touchGrid = TouchGrid(userId: userId, viewContainer: viewContainer)
		self.phrases = phrases
		let (rows, cols) = settings.getGridSize()
		self.gridSize = rows * cols
		
		self.index = 0
		self.refillGrid()
	}
	
	/*
	*	refills the touch grid with the content of the next set of phrases stored in
	*	the string array 'phrases' starting at index location 'index'
	*/
	func refillGrid() {
		let lastIndex = min(phrases.count - 1, index + gridSize - 5)
		//	functional grid cells are recognized by the four phrases mentioned below
		var gridPhrases = Array(phrases[index...lastIndex])
		if (gridPhrases.count < gridSize - 4) {	//	add dummy elements
			//	the string '---' represents a dummy cell in the grid
			//	need to change this depending on how dummy cells are identified
			gridPhrases += [String](repeating: "---", count: gridSize - gridPhrases.count - 4)
		}
		gridPhrases += ["Oops","Next","Home","Done"]
		
		touchGrid!.resetTouchGrid()
		touchGrid!.fillTouchGrid(phrases: gridPhrases)
		index = (lastIndex + 1) % phrases.count
	}
	
	/*
	*	This function selects the currently highlighted phrase in the grid and performs computation
	*	on it depending on whether it is an action button or whether it is a phrase; and it does nothing if currently
	*	more than a single phrase is highlighted in the grid
	*	a more suitable function name can be considered since its name is the same as a function in the TouchGrid class
	*/
	func makeSelection() {
		let choice:String? = touchGrid!.makeSelection()
		
		if(choice == nil) { // If we're still scanning deeper
			return
		}
		
		guard let actionButton = ActionButton(rawValue: choice!) else {
			if (choice == "---") {
				//	dummy grid cell
				//	do nothing i.e. continue scanning
				//	some code that Ning is working on will probably be merged with this...since
				//	we wish to avoid scanning over dummy elements
			}
			else {
				// i.e. a phrase is selected
				//	we may update the arry of phrases and update the grid content
				breadcrumbs.push(string: choice!)
				breadcrumbs.updateSubViews(insideView: viewContainer)
				let nextSetOfPhrases = ["juice","sun","sleep","awake","friend","teacher"]
				self.updatePhrases(phrases: nextSetOfPhrases)
			}
			return
		}
		
		ButtonAction.callAction(actionButton: actionButton, touchSelection: self)
	}
	
	/*
	*	update the set of phrases from which we wish to select
	*/
	func updatePhrases(phrases: [String]) {
		
		self.phrases = phrases
		self.index = 0
		self.refillGrid()
	}

	
}
