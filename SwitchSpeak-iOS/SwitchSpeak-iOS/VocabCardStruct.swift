//
//  VocabCardClass.swift
//  SwitchSpeak-iOS
//
//  Created by Arthur Befumo on 3/16/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import GRDB

struct VocabCard {
    var id: Int64?
    var type: VocabCardType
    var text: String
    var imagefile: NSData
    var parentid: Int64
    var voice: Bool
    var color: String
}

enum VocabCardType:Int {
    case empty = 0
    case action = 1
    case word = 2
    case category = 3
}

extension VocabCard : RowConvertible {
    // Initializer from database
    init(row:Row) {
        let cardType:VocabCardType = row["type"] as! VocabCardType
        let usesVoice:Bool = row["voice"] == 1
        self.init(type: cardType, text: row["text"], imagefile: row["imagefile"], voice: usesVoice, color: row["color"])
        self.id = row["id"]
        self.parentid = row["parentid"]
    }
    
    // Programmer's initializer
    init(type:VocabCardType, text:String, imagefile:NSData, voice:Bool, color:String) {
        self.id = 0
        self.parentid = 0
        self.type = type
        self.text = text
        self.imagefile = imagefile
        self.voice = voice
        self.color = color
    }
}

let EmptyVocabCard = VocabCard(type: .empty, text: "   ", imagefile: NSData(), voice: false, color: "ffffff")

let OopsVocabCard = VocabCard(type: .action, text: ActionButton.oops.rawValue, imagefile: NSData(), voice: false, color: "1aa3ff")

let HomeVocabCard = VocabCard(type: .action, text: ActionButton.home.rawValue, imagefile: NSData(), voice: false, color: "1aa3ff")

let NextVocabCard = VocabCard(type: .action, text: ActionButton.next.rawValue, imagefile: NSData(), voice: false, color: "1aa3ff")

let DoneVocabCard = VocabCard(type: .action, text: ActionButton.done.rawValue, imagefile: NSData(), voice: false, color: "1aa3ff")


