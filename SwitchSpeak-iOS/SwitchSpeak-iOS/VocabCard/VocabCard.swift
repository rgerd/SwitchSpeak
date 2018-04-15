//
//  VocabCardClass.swift
//  SwitchSpeak-iOS
//
//  Created by Arthur Befumo on 3/16/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit
import GRDB

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension UIColor {
    func getDarker() -> UIColor {
        var hue:CGFloat = 0.0, saturation:CGFloat = 0.0, brightness:CGFloat = 0.0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.8, alpha: 1.0)
    }
}

func convertColorToUIColor(_ color: String) -> UIColor {
    let rValue = CGFloat(UInt8(color[0...1], radix: 16)!)
    let gValue = CGFloat(UInt8(color[2...3], radix: 16)!)
    let bValue = CGFloat(UInt8(color[4...5], radix: 16)!)
    
    return UIColor(red: rValue/255.0, green: gValue/255.0, blue: bValue/255.0, alpha: 1.0)
}

struct VocabCard {
    var id: Int64?
    var type: VocabCardType
    var text: String
    var imagefile: Data
    var parentid: Int64
    var voice: Bool
    var color: UIColor
    var colorHex: String
    var hidden: Bool
}

enum VocabCardType:Int {
    case empty = 0
    case action = 1
    case word = 2
    case category = 3
}

extension VocabCard : RowConvertible {
    static let actionCards:[VocabCard] = [OopsVocabCard, NextVocabCard, HomeVocabCard, DoneVocabCard]
    
    // Initializer from database
    init(row:Row) {
        var cardType:VocabCardType
        switch row["type"] as Int {
        case 0:
            cardType = .empty
        case 1:
            cardType = .action
        case 2:
            cardType = .word
        case 3:
            cardType = .category
        default:
            cardType = .word
        }
        let usesVoice:Bool = row["voice"] == 1
        let isHidden:Bool = row["hidden"] == 1
        self.init(type: cardType, text: row["text"], imagefile: row["imagefile"], voice: usesVoice, color: row["color"], hidden: isHidden)
        self.id = row["id"]
        self.parentid = row["parentid"]
    }
    
    // Programmer's initializer
    init(type:VocabCardType, text:String, imagefile:Data, voice:Bool, color:String, hidden:Bool) {
        self.id = 0
        self.parentid = 0
        self.type = type
        self.text = text
        self.imagefile = imagefile
        self.voice = voice
        self.color = convertColorToUIColor(color)
        self.colorHex = color
        self.hidden = hidden
    }
    
    init() {
        self.id = 0
        self.parentid = 0
        self.type = .empty
        self.text = ""
        self.imagefile = Data()
        self.voice = false
        self.color = UIColor.brown
        self.colorHex = ""
        self.hidden = false
    }
}

let EmptyVocabCard = VocabCard(type: .empty, text: "   ", imagefile: Data(), voice: false, color: "ffffff", hidden: false)

let OopsVocabCard = VocabCard(type: .action, text: ActionButton.oops.rawValue, imagefile: UIImagePNGRepresentation(UIImage(named: "Oops")!)!, voice: false, color: "1aa3ff", hidden: false)

let HomeVocabCard = VocabCard(type: .action, text: ActionButton.home.rawValue, imagefile: UIImagePNGRepresentation(UIImage(named: "Home")!)!, voice: false, color: "1aa3ff", hidden: false)

let NextVocabCard = VocabCard(type: .action, text: ActionButton.next.rawValue, imagefile: UIImagePNGRepresentation(UIImage(named: "Next")!)!, voice: false, color: "1aa3ff", hidden: false)

let DoneVocabCard = VocabCard(type: .action, text: ActionButton.done.rawValue, imagefile: UIImagePNGRepresentation(UIImage(named: "Speak")!)!, voice: false, color: "1aa3ff", hidden: false)



