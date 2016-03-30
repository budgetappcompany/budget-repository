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
    
    private static func getCurrentDate() -> NSDateComponents {
        return NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
    }
    
    static func getTotalBalanco() -> Float {
        let contaDAO:ContaDAO = ContaDAO()
        
        let saldo:[Float] = contaDAO.getListaContas().map({conta in conta.valueForKey("saldo") as! Float})
        
        return saldo.reduce(0.0, combine:+)
    }
    
    static func getTotalReceitas() -> Float {

        let receitaDAO:ReceitaDAO = ReceitaDAO()
        let receitasDoMes = receitaDAO.getReceitasFromMonth(getCurrentDate().month, year:getCurrentDate().year)
        
        let saldo:[Float] = receitasDoMes.map({receita in receita.valueForKey("valor") as! Float})
        return saldo.reduce(0.0, combine: +)
    }
    
    static func getTotalDespesas() -> Float {

        let despesaDAO:DespesaDAO = DespesaDAO()
        let despesasDoMes = despesaDAO.getDespesasFromMonth(getCurrentDate().month, year: getCurrentDate().year)
        let saldo:[Float] = despesasDoMes.map({despesa in despesa.valueForKey("valor") as! Float})
        
        return saldo.reduce(0.0, combine: +)
    }
    
    static func getBalancoAnual() -> (Array<String>,[Double]) {
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var total:Double = 0
        var balancoMensal:[Double] = []
        let receitaDAO:ReceitaDAO = ReceitaDAO()
        let despesaDAO:DespesaDAO = DespesaDAO()
        
        for i in 1...getCurrentDate().month {
            let receitas = receitaDAO.getReceitasFromMonth(i, year:getCurrentDate().year)
            let valorReceitas:[Double] = receitas.map({result in result.valueForKey("valor") as! Double})
            total = valorReceitas.reduce(0.0, combine: +)
            
            let despesas = despesaDAO.getDespesasFromMonth(i, year:getCurrentDate().year)
            let valorDespesas:[Double] = despesas.map({result in result.valueForKey("valor") as! Double})
            total -= valorDespesas.reduce(0.0, combine: +)
            
            balancoMensal.append(total)
                
        }
        return (Array(months[0..<getCurrentDate().month]),balancoMensal)
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


/*========================================================================

let fetchRequest = NSFetchRequest(entityName: "Conta")
do {

    let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)

    for result in results {
        total += result.valueForKey("saldo")! as! Float
    }

} catch {
    print(error)
}

let currentDate = NSDate()
let currentMonth = NSCalendar.currentCalendar().components([.Month], fromDate: currentDate)

let currentYear = NSCalendar.currentCalendar().components([.Year], fromDate: NSDate())

let calendar = NSCalendar.currentCalendar()
let newDate = calendar.dateFromComponents(currentYear)

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

var firstDay:NSDate?
var lastDay:NSDate?

do{
        firstDay = newDate?.dateByAddingMonths(i)!.startOfMonth()
        lastDay = newDate?.dateByAddingMonths(i)!.endOfMonth()

        let predicate = NSPredicate(format: "(data>=%@) and (data<=%@)", firstDay!, lastDay!)
        fetchRequest.predicate = predicate

        let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
}catch{
    print(error)
}

//Map() - cria um novo array com valores vindos do array de receitas do mês
//Round() - usado para arrendondar o valor para duas casas decimais
//Reduce() - usado para somar os valores dentro do novo array vindo do map()

==========================================================================*/
