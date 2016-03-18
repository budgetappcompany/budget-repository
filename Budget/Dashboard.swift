//
//  Dashboard.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class Dashboard {
    static func getTotalBalanco() -> Float {
        var total:Float = 0.0
        let fetchRequest = NSFetchRequest(entityName: "Conta")
        do {
            
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            
            for result in results {
                total += result.valueForKey("saldo")! as! Float
            }
            
        } catch {
            print(error)
        }
        
        return total
    }
    
    static func getTotalReceitas() -> Float {
        var total:Float = 0.0
        let fetchRequest = NSFetchRequest(entityName: "Receita")
        do {
            
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            
            for result in results {
                total += result.valueForKey("valor")! as! Float
            }
            
        } catch {
            print(error)
        }
        
        return total
    }
    
//    static func getTotalDespesas() -> Float {
//        var total:Float = 0.0
//        let fetchRequest = NSFetchRequest(entityName: "Despesa")
//        do {
//            
//            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
//            
//            for result in results {
//                total += result.valueForKey("valor")! as! Float
//            }
//            
//        } catch {
//            print(error)
//        }
//        
//        return total
//    }
    
}
