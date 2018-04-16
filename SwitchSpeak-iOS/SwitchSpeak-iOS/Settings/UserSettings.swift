//
//  GlobalStore.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import UIKit

enum ScanSpeed : Double, Codable {
    case SLOWER = 10
    case MEDIUM = 5
    case FASTER = 1.5
}

enum ScanType : Int, Codable {
    case NO_SCAN
    case ROW_COLUMN
    case LINEAR
}

enum FontSize : Float, Codable {
    case SMALL = 26
    case MEDIUM = 32
    case LARGE = 44
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

/*
 Available English voice names and locales:
 Karen, AU
 Daniel, GB
 Moira, IE
 Samantha, US
 Tessa, ZA
*/
enum VoiceType : String, Codable {
    case MALE_VOICE = "Daniel"
    case FEMALE_VOICE = "Samantha"
}

let USER_SETTINGS_PICKER_OPTIONS = [
    [
        "Scan Slower",
        "Scan Medium",
        "Scan Faster"
    ],
    [
        "No Scan",
        "Row / Column",
        "Single Scan"
    ],
    [
        "Small Font",
        "Medium Font",
        "Large Font"
    ],
    [
        "Smaller Grid",
        "Medium Grid",
        "Larger Grid"
    ],
    [
        "Basic Vocab",
        "More Vocab",
        "Super Vocab"
    ],
    [
        "Male Voice",
        "Female Voice"
    ]
]

struct UserSettings : Codable {
    var name:String
    var tableName:String
    var scanSpeed:ScanSpeed
    var scanType:ScanType
    var fontSize:FontSize
    var gridSize:GridSize
    var shouldAlert:Bool
    var vocabLevel:VocabLevel
    var voiceType:VoiceType
    
    init(_ name:String) {
        self.name = name
        tableName = "User1"
        scanSpeed = .MEDIUM
        scanType = .ROW_COLUMN
        fontSize = .MEDIUM
        gridSize = .MEDIUM
        shouldAlert = true
        vocabLevel = .SLIGHTLY_MORE
        voiceType = .MALE_VOICE
    }
    
    func getVoiceName() -> String {
        return voiceType.rawValue
    }
    
    func getFontSize() -> CGFloat {
        return CGFloat(fontSize.rawValue)
    }
    
    private func parseRowsAndColumns(gridSize:GridSize) -> (Int, Int) {
        let rows_cols:[String] = gridSize.rawValue.components(separatedBy: ",")
        return (Int(rows_cols[0])!, Int(rows_cols[1])!)
    }
    
    func getGridSize() -> (Int, Int) {
        return parseRowsAndColumns(gridSize: gridSize)
    }
    
    func _getScanSpeed() -> Int {
        switch scanSpeed {
        case .SLOWER:
            return 0
        case .MEDIUM:
            return 1
        case .FASTER:
            return 2
        }
    }
    
    func _getScanType() -> Int {
        switch scanType {
        case .NO_SCAN:
            return 0
        case .ROW_COLUMN:
            return 1
        case .LINEAR:
            return 2
        }
    }
    
    func _getFontSize() -> Int {
        switch fontSize {
        case .SMALL:
            return 0
        case .MEDIUM:
            return 1
        case .LARGE:
            return 2
        }
    }
    
    func _getGridSize() -> Int {
        switch gridSize {
        case .SMALL:
            return 0
        case .MEDIUM:
            return 1
        case .LARGE:
            return 2
        }
    }
    
    func _getVocabLevel() -> Int {
        switch vocabLevel {
        case .BASIC:
            return 0
        case .SLIGHTLY_MORE:
            return 1
        case .SUPERCALIFRAGILISTICEXPIALIDOCIOUS:
            return 2
        }
    }
    
    func _getVoiceType() -> Int {
        switch voiceType {
        case .MALE_VOICE:
            return 0
        case .FEMALE_VOICE:
            return 1
        }
    }
    
    func updateSetting(withIndex ind:Int, toValue val:Int) -> UserSettings {
        var newSettings:UserSettings = self
        switch ind {
        case 0:
            switch val {
            case 0:
                newSettings.scanSpeed = .SLOWER
            case 1:
                newSettings.scanSpeed = .MEDIUM
            case 2:
                newSettings.scanSpeed = .FASTER
            default:
                fatalError("Invalid value provided for scan speed setting!")
                break
            }
            break
        case 1:
            switch val {
            case 0:
                newSettings.scanType = .NO_SCAN
            case 1:
                newSettings.scanType = .ROW_COLUMN
            case 2:
                newSettings.scanType = .LINEAR
            default:
                fatalError("Invalid value provided for scan type setting!")
                break
            }
            break
        case 2:
            switch val {
            case 0:
                newSettings.fontSize = .SMALL
            case 1:
                newSettings.fontSize = .MEDIUM
            case 2:
                newSettings.fontSize = .LARGE
            default:
                fatalError("Invalid value provided for font size setting!")
                break
            }
            break
        case 3:
            switch val {
            case 0:
                newSettings.gridSize = .SMALL
            case 1:
                newSettings.gridSize = .MEDIUM
            case 2:
                newSettings.gridSize = .LARGE
            default:
                fatalError("Invalid value provided for grid size setting!")
                break
            }
            break
        case 4:
            switch val {
            case 0:
                newSettings.vocabLevel = .BASIC
            case 1:
                newSettings.vocabLevel = .SLIGHTLY_MORE
            case 2:
                newSettings.vocabLevel = .SUPERCALIFRAGILISTICEXPIALIDOCIOUS
            default:
                fatalError("Invalid value provided for vocab level setting!")
                break
            }
            break
        case 5:
            switch val {
            case 0:
                newSettings.voiceType = .MALE_VOICE
            case 1:
                newSettings.voiceType = .FEMALE_VOICE
            default:
                fatalError("Invalid value provided for voice type setting!")
                break
            }
            break
        default:
            fatalError("Invalid index provided to updateSetting!")
            break
        }
        return newSettings
    }
}
