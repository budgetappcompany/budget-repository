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

    let formatter = NSNumberFormatter()
    
    func moeda(valor: Float) -> String{
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return formatter.stringFromNumber(valor)!
    }
    
    
}
