//
//  File.swift
//  Budget
//
//  Created by Calebe Santos on 3/14/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ContextFactory {
    private static var context:NSManagedObjectContext?
    
    static func getContext() -> NSManagedObjectContext {
        
        if (context != nil) {
            return context!
        }
        context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        return context!
    }
    
    static func getManagedObject(entityName: String) -> NSManagedObject{
        let contaEntity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: ContextFactory.getContext())
        return NSManagedObject(entity: contaEntity!, insertIntoManagedObjectContext: ContextFactory.getContext())
    }
}