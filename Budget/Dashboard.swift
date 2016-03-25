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
    
    static func getTotalDespesas() -> Float {
        var total:Float = 0.0
        let fetchRequest = NSFetchRequest(entityName: "Despesa")
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
    
    static func getBalancoAnual() -> ([Double],[String]){
        let fetchRequest = NSFetchRequest(entityName: "Receita")
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        
        let currentMonth = NSCalendar.currentCalendar().components([.Month, .Year], fromDate: date)
        var currentMonths:[String] = []
        
        for i in 0..<currentMonth.month {
            currentMonths.append(months[i])
        }
        
        let components = NSDateComponents()
        components.day = 01
        components.month = 01
        components.year = currentMonth.year
        
        let newDate = calendar.dateFromComponents(components)
        
        var total:Double = 0
        var receitasPorMes:[Double] = []
        
        do{
            for i in 0..<currentMonths.count {
                let predicate = NSPredicate(format: "(data>=%@) and (data<=%@)", (newDate?.dateByAddingMonths(i)!.startOfMonth())!, (newDate?.dateByAddingMonths(i)!.endOfMonth())!)
                fetchRequest.predicate = predicate
                let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
                
                for result in results {
                    total += result.valueForKey("valor")! as! Double
                }
                
                receitasPorMes.append(total)
                
                total = 0
            }
        }catch{
            print(error)
        }
        
        return (receitasPorMes, currentMonths)
    }
    
}
