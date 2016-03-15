//
//  Conta.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData


class Conta: NSManagedObject {
    
//    var context:NSManagedObjectContext?
    let formatter = NSNumberFormatter()
    
    static func getConta() -> Conta{
        return ContextFactory.getManagedObject("Conta") as! Conta
    }
    
    func moeda(valor: Float) -> String{
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return formatter.stringFromNumber(valor)!
    }
}
