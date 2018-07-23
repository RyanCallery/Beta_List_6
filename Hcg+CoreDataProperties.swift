//
//  Hcg+CoreDataProperties.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/22/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//
//

import Foundation
import CoreData


extension Hcg {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hcg> {
        return NSFetchRequest<Hcg>(entityName: "Hcg")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var hcgLevel: String?
    @NSManaged public var methotrexate: Bool
    @NSManaged public var patient: Patient?

}
