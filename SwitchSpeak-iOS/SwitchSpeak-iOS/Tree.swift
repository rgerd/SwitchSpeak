//
//  Tree.swift
//  SwitchSpeak-iOS
//
//  Created by Jaspal Singh on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation

class Tree {
	var rootNode: Node?
	
	init(root: Node){
		self.rootNode = root
	}
	
	init(){
		let root = Node()
		self.rootNode = root
	}
}





