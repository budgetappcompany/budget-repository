//
//  ReceitaDAO.swift
//  Budget
//
//  Created by Calebe Santos on 3/28/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData

class ReceitaDAO {
    func salvar(receita:Receita) throws {
        try receita.managedObjectContext?.save()
    }
    
    func remover(receita:Receita) throws {
        // Pega o valor da receita e o saldo da conta.
        let valorReceita = receita.valueForKey("valor")
        let valorConta = receita.conta!.valueForKey("saldo")
        
        // Subtrai o saldo da conta pelo valor da receita
        let saldoAtualConta = valorConta!.floatValue - valorReceita!.floatValue
        
        receita.conta?.setValue(saldoAtualConta, forKey: "saldo")
        
        ContextFactory.getContext().deleteObject(receita)
        try ContextFactory.getContext().save()
    }
    
    func getListaReceitas() -> [Receita]{
        let fetchRequest = NSFetchRequest(entityName: "Receita")
        do {
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            return results as! [Receita]
        } catch {
            print(error)
        }
        return []
    }
    
    func getReceitasFromMonth(month:Int, year:Int) -> [Receita] {
        let components = NSDateComponents()
        components.month = month
        components.year = year
        
        let data = NSCalendar.currentCalendar().dateFromComponents(components)
        
        let predicate = NSPredicate(format: "(data>=%@) and (data<=%@)", (data?.startOfMonth())!, (data?.endOfMonth())!)
        
        return (self.getListaReceitas() as NSArray).filteredArrayUsingPredicate(predicate) as! [Receita]
    }
    
}
