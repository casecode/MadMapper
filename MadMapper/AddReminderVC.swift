//
//  AddReminderVC.swift
//  MadMapper
//
//  Created by Casey R White on 11/4/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class AddReminderVC: UIViewController {

    @IBOutlet weak var reminderNameTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func addReminder(sender: AnyObject) {
        var reminderName = ""
        var reminderRadius = 1000.0
        
        let name = self.reminderNameTextField.text
        
        if name.isEmpty {
            self.reminderNameTextField.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            return
        } else {
            reminderName = name
        }
        
        let radius = NSString(string: self.radiusTextField.text).doubleValue
        if radius > 0 {
            reminderRadius = radius
        }
        
        println("name: \(reminderName) | radius: \(reminderRadius)")
    }
}
