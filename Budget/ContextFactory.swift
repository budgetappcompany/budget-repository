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
        let contaEntity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: getContext())
        return NSManagedObject(entity: contaEntity!, insertIntoManagedObjectContext: getContext())
    }
    
    static func getFetchedResultsController(entityName:String, firstSort:String, secondSort:String = "", sectionName:String) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: firstSort, ascending: true)
        let sortDescriptor1 = NSSortDescriptor(key: secondSort, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor1]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getContext(), sectionNameKeyPath: sectionName, cacheName: nil)
        
    }
    
    static func getFetchedResultsController(entityName:String, firstSort:String) -> NSFetchedResultsController {

        let fetchRequest = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: firstSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: getContext(), sectionNameKeyPath: nil, cacheName: nil)
    }
    
//    // MARK: - Core Data source
//    func tipoContasFetchRequest() -> NSFetchRequest{
//        let fetchRequest = NSFetchRequest(entityName: "Categoria")
//        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        return fetchRequest
//    }
//    
//    func getFetchedResultsController() -> NSFetchedResultsController {
//        
//        frc = NSFetchedResultsController(fetchRequest: tipoContasFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        return frc
//    }
    
}