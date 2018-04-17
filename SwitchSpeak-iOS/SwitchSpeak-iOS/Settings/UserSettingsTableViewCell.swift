//
//  UserSettingsTableViewCell.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 3/22/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import UIKit

class UserSettingsTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var nameLabel: UIButton!
    @IBOutlet weak var settingsInput: UIPickerView!
    public var userId:Int = 0
    public var loggedIn:Bool = false
    public var requestTableReload:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return USER_SETTINGS_PICKER_OPTIONS[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return USER_SETTINGS_PICKER_OPTIONS[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        GlobalSettings.updateSettings(forUser: userId, withIndex: component, toValue: row)
    }
    
    @IBAction func touchNameLabel(_ sender: Any) {
        GlobalSettings.setCurrentUserId(userId)
        requestTableReload!()
    }
    
    func useSettings(_ possibleSettings:UserSettings?) {
        if possibleSettings == nil {
            nameLabel.isHidden = true
            settingsInput.isHidden = true
            return
        }
        
        nameLabel.isHidden = false
        settingsInput.isHidden = false
        let settings:UserSettings! = possibleSettings!
        nameLabel.setTitle(settings.name, for: .normal)
        settingsInput.selectRow(settings._getScanSpeed(),  inComponent: 0, animated: false)
        settingsInput.selectRow(settings._getScanType(),   inComponent: 1, animated: false)
        settingsInput.selectRow(settings._getFontSize(),   inComponent: 2, animated: false)
        settingsInput.selectRow(settings._getGridSize(),   inComponent: 3, animated: false)
        settingsInput.selectRow(settings._getVocabLevel(), inComponent: 4, animated: false)
        settingsInput.selectRow(settings._getVoiceType(),  inComponent: 5, animated: false)
    }
    
    func setLoggedIn(_ loggedIn:Bool) {
        if loggedIn {
            nameLabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            nameLabel.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        }
    }
    
    func editName() -> UIAlertController {
        let alert = UIAlertController(title: "Update user name", message: "Enter Name", preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Name"
            textField.isSecureTextEntry = false
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction!) in
            let nameTextField = alert.textFields![0] as UITextField
            let newName:String = nameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
            if newName.count == 0 {
                return
            }
            GlobalSettings.userSettings[self.userId].name = newName
            self.requestTableReload!()
        }))
        return alert
    }
}
