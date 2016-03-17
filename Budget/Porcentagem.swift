//
//  Porcentagem.swift
//  Budget
//
//  Created by Calebe Santos on 3/7/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation

class Porcentagem : Calculadora {
    var porcentagem: Float = 0
    
    override init() {
        super.init()
        self.opcao = 4
    }

    func calcularPorcentagemDoValor() -> Float {
        self.numeroFinal = porcentagem/100
        
        return self.calcularOperacao()
    }
    
    func calcularValorComDesconto() -> Float {
        self.porcentagem /= 100
        self.numeroFinal = 1 - porcentagem
        return self.calcularOperacao()
    }
    
    func calcularValorComJuros() -> Float {
        self.porcentagem /= 100
        self.numeroFinal = 1 + porcentagem
        return self.calcularOperacao()
    }
    
    func calcularValorPorcentagem() -> Float {
        self.numeroFinal = self.numeroAtual/self.numeroFinal
        self.numeroAtual = 100
        return self.calcularOperacao()
    }
    
    func calcularAumentoPercentual() -> Float {
        return self.calcularValorPorcentagem() - 100
    }
    
    func calcularDiminuicaoPercentual() -> Float {
        return 100 - self.calcularValorPorcentagem()
    }
    
    func calcularValorInicialAumentado() -> Float {
        //numeroFinal = 1200
        //porcentagem = 20
        self.porcentagem += 100
        self.numeroFinal /= self.porcentagem
        self.numeroAtual = 100
        return self.calcularOperacao()
    }
    
    func calcularValorInicialDiminuido() -> Float {
        self.porcentagem = 100 - self.porcentagem
        self.numeroFinal /= self.porcentagem
        self.numeroAtual = 100
        return self.calcularOperacao()
    }
}