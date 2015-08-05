//
//  Note.swift
//  SampleCalendar
//
//  Created by ram on 02/07/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import Foundation
import CoreData

class Note: NSManagedObject {

    @NSManaged var createdOn: NSDate
    @NSManaged var title: String
    @NSManaged var noteDescription: String
    @NSManaged var color: AnyObject

}
