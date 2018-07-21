//
//  Patient+CoreDataProperties.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/19/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//
//

import Foundation
import CoreData


extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var medicalRecordNumber: String?
    @NSManaged public var telephoneNumber: String?
    @NSManaged public var age: String?
    @NSManaged public var parity: String?
    @NSManaged public var gestationalAge: String?
    @NSManaged public var historyOfPresentIllness: String?
    @NSManaged public var hcg: NSOrderedSet?
    @NSManaged public var ultrasound: NSOrderedSet?

}

// MARK: Generated accessors for hcg
extension Patient {

    @objc(insertObject:inHcgAtIndex:)
    @NSManaged public func insertIntoHcg(_ value: Hcg, at idx: Int)

    @objc(removeObjectFromHcgAtIndex:)
    @NSManaged public func removeFromHcg(at idx: Int)

    @objc(insertHcg:atIndexes:)
    @NSManaged public func insertIntoHcg(_ values: [Hcg], at indexes: NSIndexSet)

    @objc(removeHcgAtIndexes:)
    @NSManaged public func removeFromHcg(at indexes: NSIndexSet)

    @objc(replaceObjectInHcgAtIndex:withObject:)
    @NSManaged public func replaceHcg(at idx: Int, with value: Hcg)

    @objc(replaceHcgAtIndexes:withHcg:)
    @NSManaged public func replaceHcg(at indexes: NSIndexSet, with values: [Hcg])

    @objc(addHcgObject:)
    @NSManaged public func addToHcg(_ value: Hcg)

    @objc(removeHcgObject:)
    @NSManaged public func removeFromHcg(_ value: Hcg)

    @objc(addHcg:)
    @NSManaged public func addToHcg(_ values: NSOrderedSet)

    @objc(removeHcg:)
    @NSManaged public func removeFromHcg(_ values: NSOrderedSet)

}

// MARK: Generated accessors for ultrasound
extension Patient {

    @objc(insertObject:inUltrasoundAtIndex:)
    @NSManaged public func insertIntoUltrasound(_ value: Ultrasound, at idx: Int)

    @objc(removeObjectFromUltrasoundAtIndex:)
    @NSManaged public func removeFromUltrasound(at idx: Int)

    @objc(insertUltrasound:atIndexes:)
    @NSManaged public func insertIntoUltrasound(_ values: [Ultrasound], at indexes: NSIndexSet)

    @objc(removeUltrasoundAtIndexes:)
    @NSManaged public func removeFromUltrasound(at indexes: NSIndexSet)

    @objc(replaceObjectInUltrasoundAtIndex:withObject:)
    @NSManaged public func replaceUltrasound(at idx: Int, with value: Ultrasound)

    @objc(replaceUltrasoundAtIndexes:withUltrasound:)
    @NSManaged public func replaceUltrasound(at indexes: NSIndexSet, with values: [Ultrasound])

    @objc(addUltrasoundObject:)
    @NSManaged public func addToUltrasound(_ value: Ultrasound)

    @objc(removeUltrasoundObject:)
    @NSManaged public func removeFromUltrasound(_ value: Ultrasound)

    @objc(addUltrasound:)
    @NSManaged public func addToUltrasound(_ values: NSOrderedSet)

    @objc(removeUltrasound:)
    @NSManaged public func removeFromUltrasound(_ values: NSOrderedSet)

}
