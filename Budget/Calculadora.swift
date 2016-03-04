//
//  Calculadora.swift
//  Budget
//
//  Created by md10 on 3/3/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class Calculadora: NSObject {
    var numeroAtual:Float = 0
//    var segundoValor:Float = 0
    var resultadoOp:Float = 0
    var opcao:Int = 0
    
    func calcularOperacao() -> Float {
        switch(opcao){
            case 1:
                resultadoOp += numeroAtual
                break;
            case 2:
                resultadoOp -= numeroAtual
                break;
            case 3:
                resultadoOp /= numeroAtual
                break;
            case 4:
                resultadoOp *= numeroAtual
                break;
            default:
                break;
        }
        
        return resultadoOp
    }
}
