//
//  Despesa+CoreDataProperties.swift
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

extension Despesa {

    @NSManaged var nome: String?
    @NSManaged var descricao: String?
    @NSManaged var valor: NSNumber?
    @NSManaged var endereco: String?
    @NSManaged var longitude: String?
    @NSManaged var latitude: String?
    @NSManaged var flgTipo: String?
    @NSManaged var data: NSDate?
    @NSManaged var categoria: NSManagedObject?
    @NSManaged var conta: NSManagedObject?

}
