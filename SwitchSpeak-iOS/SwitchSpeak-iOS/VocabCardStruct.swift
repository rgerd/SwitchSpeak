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
    var type: Int // 0 is empty, 1 is action, 2 is word, 3 is category
    var text: String
    var imagefile: NSData
    var parentid: Int64
    var voice: Int
    var color: String
}

extension VocabCard : RowConvertible {
    init(row:Row) {
        id = row["id"]
        type = row["type"]
        text = row["text"]
        imagefile = row["imagefile"]
        parentid = row["parentid"]
        voice = voice["voice"]
        color = color["color"]
    }
}
