//
//  GlobalSettings.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 2/26/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation

// Example usage:
// Set user 2's font size to large:
// GlobalSettings.userSettings[2].fontSize = .LARGE

class GlobalSettings {
    static var userSettings:[UserSettings] = []

    static func populateUserSettings() {
        if Storage.fileExists("userSettings.json", in: .documents) {
            let settingsFromDisk:[UserSettings] = Storage.retrieve("userSettings.json", from: .documents, as: [UserSettings].self)
            userSettings.append(contentsOf: settingsFromDisk)
        }
    }
    
    static func saveUserSettings() {
        Storage.store(userSettings, to: .documents, as: "userSettings.json")
    }
    
    // Returns the user ID of the created user
    static func createUser() -> Int {
        userSettings.append(UserSettings())
        return userSettings.count - 1
    }
}
