//
//  TextoMascara.swift
//  Budget
//
//  Created by Calebe Santos on 3/27/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation

extension String {
    var lastChar:String {
        return self.substringFromIndex((self.endIndex.predecessor()))
    }
    mutating func removeLastChar() {
        self.removeAtIndex(self.endIndex.predecessor())
    }
}

class TextoMascara {
    
    static func aplicarMascara(var text: String) -> String {
        formatText(&text)
        switch text.lastChar {
        case "0","1","2","3","4","5","6","7","8","9":
            break;
        default:
            text.removeLastChar()
        }
        
        return formatCurrency(text)
    }
    
    
    
    static private func formatText(inout priceS: String) {
        priceS = priceS.stringByReplacingOccurrencesOfString("R$",withString:"")
        priceS = priceS.stringByReplacingOccurrencesOfString(".",withString:"")
        priceS = priceS.stringByReplacingOccurrencesOfString(",",withString:"")
    }
    
    static private func formatCurrency(string: String) -> String{
        var numberFromField:Float?
        numberFromField = string.floatConverter/100
        return numberFromField!.convertToMoedaBr()
    }
}
