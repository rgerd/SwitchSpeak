//
//  GlobalStore.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation

enum ScanSpeed : Double, Codable {
    case SLOW = 0.8
    case MEDIUM = 0.5
    case FAST = 0.25
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

enum GridSize : String, Codable {
    case SMALL = "2,3"
    case MEDIUM = "3,4"
    case LARGE = "4,5"
}

enum VocabLevel : Int, Codable {
    case BASIC
    case SLIGHTLY_MORE
    case SUPERCALIFRAGILISTICEXPIALIDOCIOUS
}

func parseRowsAndColumns(gridSize:GridSize) -> (Int, Int) {
    let rows_cols:[String] = gridSize.rawValue.components(separatedBy: ",")
    return (Int(rows_cols[0])!, Int(rows_cols[1])!)
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