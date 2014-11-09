//
//  Reminder.swift
//  MadMapper
//
//  Created by Casey R White on 11/5/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Reminder: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var createdDate: NSDate
    @NSManaged var radius: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}

extension Reminder {
    func setAttributes(#name: String, centerCoordinate center: CLLocationCoordinate2D, radius: Double) {
        self.name = name
        self.latitude = center.latitude
        self.longitude = center.longitude
        self.radius = radius
        self.createdDate = NSDate()
    }
    
    func centerCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue)
    }
}
