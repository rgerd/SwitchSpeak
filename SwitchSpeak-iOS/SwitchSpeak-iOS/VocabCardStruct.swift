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
    var target: String
    var text: String
    var imagefile: NSData
    var parentid: Int64
    var voice: Int
    var color: String
}

extension VocabCard : RowConvertible {
    init(row:Row) {
        id = row["id"]
        target = row["target"]
        text = row["text"]
        imagefile = row["imagefile"]
        parentid = row["parentid"]
        voice = voice["voice"]
        color = color["color"]
    }
}
