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
	var touchGrid:TouchGrid?
	var breadcrumbs = CrumbStack()
    var breadcrumbContainer:UIView?
	var pageOffset:Int
    var screenId:Int64
	
	init(breadcrumbContainer:UIView, gridContainer:UIView) {
        self.breadcrumbContainer = breadcrumbContainer
		self.touchGrid = TouchGrid(gridContainer: gridContainer)
        self.pageOffset = 0
        self.screenId = 0
		self.refillGrid()
	}
	
	/*
	 *	Refills the touch grid with the content of the next set of phrases stored in
	 *	the string array 'phrases' starting at index location 'index'
	 */
	func refillGrid() {
        refillGrid(withoutPaging: false)
	}
    
    func refillGrid(withoutPaging:Bool) {
        if withoutPaging {
            pageOffset = 0 // For now. We will want to just reset to page boundary in the future
        }
        let settings:UserSettings = GlobalSettings.getUserSettings()
        let cards:[VocabCard] = VocabCardDB.shared!.getCardArray(inTable: settings.tableName, withId: self.screenId)
        
        let (rows, cols) = settings.getGridSize()
        let gridSize:Int = rows * cols
        
        let lastIndex:Int = min(cards.count, pageOffset + gridSize - VocabCard.actionCards.count) - 1
        var gridCards = Array(cards[pageOffset...lastIndex])
        
        //    next we add dummy elements for the remaining grid cells excluding the last 4 cells,
        //    which correspond to the 4 action buttons (home,done,oops,next)
        if (gridCards.count < gridSize - VocabCard.actionCards.count) {
            gridCards += [VocabCard](repeating: EmptyVocabCard, count: gridSize - gridCards.count - VocabCard.actionCards.count)
        }
        
        //    functional grid cells or action buttons are recognized by the four phrases mentioned below
        gridCards += VocabCard.actionCards
		
		touchGrid!.resetTouchGrid()
        touchGrid!.fillTouchGrid(cards: gridCards)

        pageOffset = (lastIndex + 1) % cards.count
    }
	
   /*
	*	This function selects the currently highlighted phrase in the grid and performs computation
	*	on it depending on whether it is an action button or whether it is a phrase; and it does nothing if currently
	*	more than a single phrase is highlighted in the grid
	*	a more suitable function name can be considered since its name is the same as a function in the TouchGrid class
	*/
	func makeSelection() {
		let choice:ButtonNode? = touchGrid!.makeSelection()
		if(choice == nil) { // If we're still scanning deeper
			return
		}
        choice!.select()
	}
    
    func selectCard(_ card:VocabCard) {
        // i.e. a phrase is selected
        //    we may update the array of phrases and update the grid content
        breadcrumbs.push(cardData: card)
        breadcrumbs.updateSubViews(insideView: breadcrumbContainer!)
        
        // say word on selection if necessary
        if card.voice {
            SpeechManager.say(phrase: card.text, withVoice: GlobalSettings.getUserSettings().voiceType.rawValue)
        }
        
        if card.type == .category {
            self.setScreenId(card.id!)
        }
    }
	
   /*
	*	update the set of phrases from which we wish to select
	*/
	func pageNext() {
		self.refillGrid()
	}
    
    func setScreenId(_ id: Int64) {
        self.pageOffset = 0
        self.screenId = id
        self.refillGrid()
    }
}


