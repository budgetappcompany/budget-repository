//
//  Conta.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import CoreData

enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}

extension String {
    var floatConverter: Float {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        
        var decimal:NSNumber?
        
        if let result = converter.numberFromString(self) {
            decimal = result
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                decimal = result
            }
        }
        
        if let decimalConverter = decimal?.floatValue {
            return decimalConverter
        }
        
        print("Erro floatConverter")
        return 0
    }
    
    func floatConverterMoeda() -> Float {
        var result = self
        
        result = result.stringByReplacingOccurrencesOfString("R$",withString:"")
        result = result.stringByReplacingOccurrencesOfString(".",withString:"")
        result = result.stringByReplacingOccurrencesOfString(",",withString:".")

        return result.floatConverter
    }
}

extension Float {
    func convertToMoedaBr() -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return (formatter.stringFromNumber(self))!
    }
}

class Conta: NSManagedObject {
    
//    var context:NSManagedObjectContext?
    let formatter = NSNumberFormatter()
    
    static func getConta() -> Conta{
        return ContextFactory.getManagedObject("Conta") as! Conta
    }
    
    static func getContasController(firstSort:String, secondSort:String = "", sectionName:String) -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsController("Conta", firstSort: firstSort, secondSort: secondSort, sectionName: sectionName)
    }

    func moeda(valor: Float) -> String{
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return (formatter.stringFromNumber(valor))!
    }
    
    
    
    
}
