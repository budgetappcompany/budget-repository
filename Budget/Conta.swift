//
//  Conta.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData

extension String {
    var floatConverter: Float {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.numberFromString(self) {
            return result.floatValue
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                return result.floatValue
            }
        }
        return 0
    }
}

class Conta: NSManagedObject {
    
//    var context:NSManagedObjectContext?
    let formatter = NSNumberFormatter()
    
    static func getConta() -> Conta{
        return ContextFactory.getManagedObject("Conta") as! Conta
    }
    
    func moeda(valor: Float) -> String{
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return (formatter.stringFromNumber(valor))!
    }
    

    
    
}
