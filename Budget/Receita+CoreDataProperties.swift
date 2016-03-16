//
//  Receita+CoreDataProperties.swift
//  Budget
//
//  Created by Yuri Pereira on 3/16/16.
//  Copyright © 2016 Budget. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Receita {

    @NSManaged var nome: String?
    @NSManaged var descricao: String?
    @NSManaged var valor: NSNumber?
    @NSManaged var data: NSDate?
    @NSManaged var endereco: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var conta: NSManagedObject?

}
