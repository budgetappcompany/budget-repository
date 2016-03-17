//
//  Conta+CoreDataProperties.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Conta {

    @NSManaged var nome: String?
    @NSManaged var saldo: NSNumber?
    @NSManaged var tipoconta: NSManagedObject?
    @NSManaged var receita: NSSet?

}
