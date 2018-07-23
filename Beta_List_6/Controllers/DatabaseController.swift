//
//  DatabaseController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/19/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications


class DatabaseController {
    
    private init(){
        
    }
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext 
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Beta_List_6")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
