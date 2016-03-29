//
//  CategoriaDAO.swift
//  Budget
//
//  Created by Calebe Santos on 3/28/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData


class CategoriaDAO {
    
    func salvar(categoria:Categoria) throws {
        try categoria.managedObjectContext?.save()
    }
    
    func remover(categoria:Categoria) throws {
        ContextFactory.getContext().deleteObject(categoria)
        try ContextFactory.getContext().save()
    }
    
    func getListaCategorias() -> [Categoria]{
        let fetchRequest = NSFetchRequest(entityName: "Categoria")
        do {
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            return results as! [Categoria]
        } catch {
            print(error)
        }
        return []
    }
}
