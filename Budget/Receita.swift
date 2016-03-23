//
//  Receita.swift
//  Budget
//
//  Created by Yuri Pereira on 3/16/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData

class Receita: NSManagedObject {

    static func getReceita() -> Receita{
        return ContextFactory.getManagedObject("Receita") as! Receita
    }
    
    static func getFetchedResultsReceita(firstSort:String, secondSort:String = "", sectionName:String) -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsController("Receita", firstSort: firstSort, secondSort: secondSort, sectionName: sectionName)
    }

}
