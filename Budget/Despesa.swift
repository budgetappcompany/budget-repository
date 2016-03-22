//
//  Despesa.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData


class Despesa: NSManagedObject {

    static func getDespesa() -> Despesa{
        return ContextFactory.getManagedObject("Despesa") as! Despesa
    }

}
