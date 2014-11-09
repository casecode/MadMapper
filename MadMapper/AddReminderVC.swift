//
//  AddReminderVC.swift
//  MadMapper
//
//  Created by Casey R White on 11/4/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddReminderVC: UIViewController {

    @IBOutlet weak var reminderNameTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: MKAnnotation!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
    }

    @IBAction func addReminder(sender: AnyObject) {
        var reminderName = self.reminderNameTextField.text
        if reminderName.isEmpty {
            self.reminderNameTextField.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            return
        }
        
        var reminderRadius = 1000.0
        let inputRadius = NSString(string: self.radiusTextField.text).doubleValue
        if inputRadius > 0 { reminderRadius = inputRadius }
        
        let geoRegion = CLCircularRegion(center: self.selectedAnnotation.coordinate, radius: reminderRadius, identifier: reminderName)
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        let reminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.managedObjectContext) as Reminder
        reminder.setAttributes(name: reminderName, centerCoordinate: geoRegion.center, radius: reminderRadius)
        
        var error: NSError? = nil
        self.managedObjectContext.save(&error)
        if (error != nil) {
            println("Error saving reminder: \(error?.localizedDescription)")
        }
        
        let info = ["region" : geoRegion]
        NSNotificationCenter.defaultCenter().postNotificationName("ReminderAdded", object: self, userInfo: info)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelReminder(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
