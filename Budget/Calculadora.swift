//
//  Calculadora.swift
//  Budget
//
//  Created by md10 on 3/3/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class Calculadora {
    var numeroAtual:Float = 0
//    var segundoValor:Float = 0
    var numeroFinal:Float = 0
    var opcao:Int = 0
    
    func calcularOperacao() -> Float {
        switch(opcao){
            case 1:
                numeroFinal += numeroAtual
                break;
            case 2:
                numeroFinal -= numeroAtual
                break;
            case 3:
                numeroFinal /= numeroAtual
                break;
            case 4:
                numeroFinal *= numeroAtual
                break;
            default:
                break;
        }
        
        return numeroFinal
    }
}
