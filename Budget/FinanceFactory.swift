//
//  FinanceFactory.swift
//  Budget
//
//  Created by Calebe Santos on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import JavaScriptCore

class Finance {
    let context:JSContext?
    
    init(){
        
        context = JSContext()
        
        do {
            
            let path = NSBundle.mainBundle().pathForResource("finance", ofType: "js")
    
            let url = NSURL(fileURLWithPath: path!)
            let jscript = try String.init(contentsOfURL: url)
    
            context?.evaluateScript(jscript)
            context?.evaluateScript("var finance = new Finance();")
            
        } catch {
            print(error)
        }
    }
    
    func calculateCompoundInterest(valorAVista: Double, _ numeroDeParcelas: Int, _ valorDaParcela: Double) -> Double {
        var taxaDeJuros = 0.005;
        var qtdTaxasIguais = 0.0;
        var taxaDeJurosNova = 0.0;
        var i = 0;
        
        while(qtdTaxasIguais < 35){
            taxaDeJurosNova = (valorDaParcela/valorAVista) * (1-pow(Double(1+taxaDeJuros),Double(-numeroDeParcelas)))
            
            let x = Double(round(100000000*taxaDeJurosNova)/100000000)
            let y = Double(round(100000000*taxaDeJuros)/100000000)
            
            if(x == y){
                qtdTaxasIguais++
            } else {
                qtdTaxasIguais = 0
            }
            i++
            taxaDeJuros = taxaDeJurosNova
        }
        
        return Double(round(10000*taxaDeJuros)/100)
    }
    
//    var valorAVista = 1499.99;
//    var numeroParcelas = 10;
//    var valorDaParcela = 159.99;
//    var taxaDeJuros = 0.005;
//    var qtdTaxasIguais = 0;
//    var taxaDeJurosNova = 0;
//    var i = 0;
//    while(qtdTaxasIguais < 35){
//    taxaDeJurosNova = (valorDaParcela/valorAVista)*(1-Math.pow((1+taxaDeJuros),-numeroParcelas));
//    if(taxaDeJurosNova.toFixed(8) == taxaDeJuros.toFixed(8)){
//    qtdTaxasIguais++;
//    } else {
//    qtdTaxasIguais = 0;
//    }
//    i++;
//    taxaDeJuros = taxaDeJurosNova;
//    //console.log(taxaDeJurosNova.toFixed(8)*100);
//    }
//    console.log(i);
//    alert((taxaDeJuros*100).toFixed(2));
}