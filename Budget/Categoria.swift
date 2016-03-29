//
//  Categoria.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData


class Categoria: NSManagedObject {

    static func getCategoria() -> Categoria{
        return ContextFactory.getManagedObject("Categoria") as! Categoria
    }
    
    static func getCategoriasController() -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsControllerrr()
    }

}
