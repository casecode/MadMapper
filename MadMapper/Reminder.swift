//
//  Reminder.swift
//  MadMapper
//
//  Created by Casey R White on 11/5/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var createdDate: NSDate
    @NSManaged var radius: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}
