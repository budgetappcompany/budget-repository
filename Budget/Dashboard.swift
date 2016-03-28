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
    
    static func getBalancoAnual() -> (Array<String>,[Double]){
        let fetchRequest = NSFetchRequest(entityName: "Receita")
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        let currentDate = NSDate()
        let currentMonth = NSCalendar.currentCalendar().components([.Month], fromDate: currentDate)
        let currentYear = NSCalendar.currentCalendar().components([.Year], fromDate: currentDate)

        let calendar = NSCalendar.currentCalendar()
        let newDate = calendar.dateFromComponents(currentYear)
        
        var total:Double = 0
        var receitasPorMes:[Double] = []
        
        var firstDay:NSDate?
        var lastDay:NSDate?
        
        do{
            for i in 0..<currentMonth.month {
                firstDay = newDate?.dateByAddingMonths(i)!.startOfMonth()
                lastDay = newDate?.dateByAddingMonths(i)!.endOfMonth()
                
                let predicate = NSPredicate(format: "(data>=%@) and (data<=%@)", firstDay!, lastDay!)
                fetchRequest.predicate = predicate
                
                let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
                
                //Map() - cria um novo array com valores vindos do array de receitas do mês
                let valores = results.map({result in result.valueForKey("valor") as! Double})
                
                //Round() - usado para arrendondar o valor para duas casas decimais
                //Reduce() - usado para somar os valores dentro do novo array vindo do map()
                total = round(100*valores.reduce(0.0,combine: +))/100
                
                receitasPorMes.append(total)
            }
        }catch{
            print(error)
        }
        
        return (Array(months[0..<currentMonth.month]),receitasPorMes)
    }
    
    static func getDespesasPorCategoria() -> ([String],[Double]) {
        
        var fetchRequest = NSFetchRequest(entityName: "Categoria")
        var total:Double = 0
        var despesasPorCategoria:[Double] = []
        var categorias:[String]?
        do {
            let cats = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            categorias = cats.map({cat in cat.valueForKey("nome") as! String})
            fetchRequest = NSFetchRequest(entityName: "Despesa")
            
            for categoria in categorias! {
                let predicate = NSPredicate(format:"categoria.nome = %@", categoria)
                fetchRequest.predicate = predicate
                
                let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
                
                let valores = results.map({result in result.valueForKey("valor") as! Double})
                
                total = round(100*valores.reduce(0.0,combine: +))/100
                
                despesasPorCategoria.append(total)
            }
        } catch {
            print(error)
        }
        
        return (categorias!, despesasPorCategoria)
    }
    
    static func getReceitasPorCategoria() -> ([String],[Double]) {
        
        var fetchRequest = NSFetchRequest(entityName: "Categoria")
        var total:Double = 0
        var receitasPorCategoria:[Double] = []
        var categorias:[String]?
        do {
            let cats = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            categorias = cats.map({cat in cat.valueForKey("nome") as! String})
            fetchRequest = NSFetchRequest(entityName: "Receita")
            
            for categoria in categorias! {
                let predicate = NSPredicate(format:"categoria.nome = %@", categoria)
                fetchRequest.predicate = predicate
                
                let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
                
                let valores = results.map({result in result.valueForKey("valor") as! Double})
                
                total = round(100*valores.reduce(0.0,combine: +))/100
                
                receitasPorCategoria.append(total)
            }
        } catch {
            print(error)
        }
        
        return (categorias!, receitasPorCategoria)
    }
    
}
