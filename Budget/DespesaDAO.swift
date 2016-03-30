//
//  DespesaDAO.swift
//  Budget
//
//  Created by Calebe Santos on 3/28/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation

import Foundation
import CoreData


class DespesaDAO {
    
    func salvar(depesa:Despesa) throws {
        try ContextFactory.getContext().save()
    }
    
    func remover(despesa:Despesa) throws {
        
        // Pega o valor da despesa e o saldo da conta.
        let valorDespesa = despesa.valueForKey("valor")
        let valorConta = despesa.conta!.valueForKey("saldo")
        
        // Soma o saldo da conta pelo valor da despesa
        let saldoAtualConta = valorConta!.floatValue + valorDespesa!.floatValue
        
        // Atualiza o saldo da conta somando o valor da despesa que estava cadastrada
        despesa.conta?.setValue(saldoAtualConta, forKey: "saldo")
        
        ContextFactory.getContext().deleteObject(despesa)
        try ContextFactory.getContext().save()
    }
    
    func getListaDespesas() -> [Despesa]{
        let fetchRequest = NSFetchRequest(entityName: "Despesa")
        do {
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            return results as! [Despesa]
        } catch {
            print(error)
        }
        return []
    }
    
    func getDespesasFromMonth(month:Int, year:Int) -> [Despesa] {
        let components = NSDateComponents()
        components.month = month
        components.year = year
        
        let data = NSCalendar.currentCalendar().dateFromComponents(components)
        
        let predicate = NSPredicate(format: "(data>=%@) and (data<=%@)", (data?.startOfMonth())!, (data?.endOfMonth())!)
        
        return (self.getListaDespesas() as NSArray).filteredArrayUsingPredicate(predicate) as! [Despesa]
    }
    
}
