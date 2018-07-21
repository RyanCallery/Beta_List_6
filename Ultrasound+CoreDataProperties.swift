//
//  Ultrasound+CoreDataProperties.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/19/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//
//

import Foundation
import CoreData


extension Ultrasound {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ultrasound> {
        return NSFetchRequest<Ultrasound>(entityName: "Ultrasound")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var uterus: String?
    @NSManaged public var leftOvary: String?
    @NSManaged public var rightOvary: String?
    @NSManaged public var fluid: String?
    @NSManaged public var patient: Patient?

}
