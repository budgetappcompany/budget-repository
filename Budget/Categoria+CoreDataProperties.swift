//
//  Categoria+CoreDataProperties.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Categoria {

    @NSManaged var nome: String?
    @NSManaged var receita: NSSet?
    @NSManaged var despesa: NSSet?

}
