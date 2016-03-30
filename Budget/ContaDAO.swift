//
//  ContaDAO.swift
//  Budget
//
//  Created by Calebe Santos on 3/28/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData

class ContaDAO {
    func salvar(conta:Conta) throws {
        try conta.managedObjectContext?.save()
    }
    
    func remover(conta:Conta) throws {
        ContextFactory.getContext().deleteObject(conta)
        try ContextFactory.getContext().save()
    }
    
    func getListaContas() -> [Conta]{
        let fetchRequest = NSFetchRequest(entityName: "Conta")
        do {
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            return results as! [Conta]
        } catch {
            print(error)
        }
        return []
    }
}