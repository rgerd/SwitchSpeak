//
//  GlobalStore.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation

enum ScanSpeed : Int, Codable {
    case SLOW
    case MEDIUM
    case FAST
}

enum ScanType : Int, Codable {
    case BINARY_TREE
    case ROW_COLUMN
    case LINEAR
}

enum FontSize : Int, Codable {
    case SMALL
    case MEDIUM
    case LARGE
}

enum GridSize : Int, Codable {
    case SMALL
    case MEDIUM
    case LARGE
}

enum VocabLevel : Int, Codable {
    case BASIC
    case SLIGHTLY_MORE
    case SUPERCALIFRAGILISTICEXPIALIDOCIOUS
}

struct UserSettings : Codable {
    var scanSpeed:ScanSpeed
    var scanType:ScanType
    var fontSize:FontSize
    var gridSize:GridSize
    var shouldAlert:Bool
    var vocabLevel:VocabLevel
    
    init() {
        scanSpeed = .MEDIUM
        scanType = .ROW_COLUMN
        fontSize = .MEDIUM
        gridSize = .MEDIUM
        shouldAlert = true
        vocabLevel = .SLIGHTLY_MORE
    }
}
