//
//  Calculadora.swift
//  Budget
//
//  Created by md10 on 3/3/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class Calculadora: NSObject {
    var primeiroValor:Float = 0
    var segundoValor:Float = 0
    var resultadoOp:Float = 0
    var opcao:Int = 0
    
    func calcularOperacao() -> Float {
        switch(opcao){
            case 1:
                resultadoOp = segundoValor + primeiroValor
                break;
            case 2:
                resultadoOp = segundoValor - primeiroValor
                break;
            case 3:
                resultadoOp = segundoValor / primeiroValor
                break;
            case 4:
                resultadoOp = segundoValor * primeiroValor
                break;
            default:
                break;
        }
        
        return resultadoOp
    }
    
    static func calcularOperacao(primeiroValor:Float,segundoValor:Float,opcao:Int) -> Float {
        
        var resultadoOp:Float = 0
        
        switch(opcao){
        case 1:
            resultadoOp = primeiroValor + segundoValor
            break;
        case 2:
            resultadoOp = primeiroValor - segundoValor
            break;
        case 3:
            resultadoOp = primeiroValor / segundoValor
            break;
        case 4:
            resultadoOp = primeiroValor * segundoValor
            break;
        default:
            break;
        }
        
        return resultadoOp
    }
}
