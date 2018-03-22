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
    static var currentUserId:Int = 0

    // Loads and restores all saved user settings. Also creates the test user.
    static func populateUserSettings() {
        self.userSettings = []
        let _ = createUser() // Create the test user 0
        if Storage.fileExists("userSettings.json", in: .documents) {
            let settingsFromDisk:[UserSettings] = Storage.retrieve("userSettings.json", from: .documents, as: [UserSettings].self)
            self.userSettings.append(contentsOf: settingsFromDisk)
        }
    }
    
    // Saves all user settings to disk, except for test user 0
    static func saveUserSettings() {
        Storage.store(Array(self.userSettings[1...]), to: .documents, as: "userSettings.json")
    }
    
    // Returns the user ID of the created user
    static func createUser() {
        self.userSettings.append(UserSettings("User \(self.userSettings.count)"))
    }
    
    static func removeUser(byId userId:Int) {
        if userId == 0 {
            return
        }
        self.userSettings.remove(at: userId)
        if self.currentUserId == userId {
            self.currentUserId -= 1
        }
    }
    
    // Sets the current user id to be used across the app.
    static func setCurrentUserId(_ userId:Int) {
        self.currentUserId = userId
    }
    
    // A convenience method for getting the settings for the current user.
    static func getUserSettings() -> UserSettings {
        return self.userSettings[currentUserId]
    }
    
    static func countUsers() -> Int {
        return self.userSettings.count
    }
    
    static func updateSettings(forUser userId:Int, withIndex index:Int, toValue value:Int) {
        self.userSettings[userId] = self.userSettings[userId].updateSetting(withIndex: index, toValue: value)
    }
}
