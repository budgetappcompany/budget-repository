//
//  TipoConta.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData


class TipoConta: NSManagedObject {

    static func getTipoConta() -> TipoConta{
        return ContextFactory.getManagedObject("TipoConta") as! TipoConta
    }
    
    static func getTipoContasController(firstSort:String) -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsController("TipoConta", firstSort: firstSort)
    }

}
