//
//  CalculadoraJurosController.swift
//  Budget
//
//  Created by Calebe Santos on 3/7/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class PorcentagemController: UIViewController {

    var calculadora: Calculadora?
    
    @IBOutlet weak var txtPrimeiroValor: UITextField!
    @IBOutlet weak var txtSegundoValor: UITextField!
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var sgmTipo: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculadora = Porcentagem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calcularValorPorcentagem(sender: UIButton) {
        //Porcentagem do valor
        calculadora?.numeroAtual = txtPrimeiroValor.text!.floatValue
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtSegundoValor.text!.floatValue
            print(calculadora.calcularPorcentagemDoValor())
        }
    }
    
    @IBAction func calcularPercentualValor(sender: UIButton) {
        //Valor porcentagem
        calculadora?.numeroAtual = txtPrimeiroValor.text!.floatValue
        calculadora?.numeroFinal = txtSegundoValor.text!.floatValue
        if let calculadora = calculadora as? Porcentagem {
            print(calculadora.calcularValorPorcentagem())
        }
    }
    
    @IBAction func calcularVariacao(sender: UIButton) {
        //Aumento percentual
        calculadora?.numeroAtual = txtPrimeiroValor.text!.floatValue
        calculadora?.numeroFinal = txtSegundoValor.text!.floatValue
        if let calculadora = calculadora as? Porcentagem {
            print(calculadora.calcularAumentoPercentual())
        }
        
        //Diminuição percentual
        calculadora?.numeroAtual = txtPrimeiroValor.text!.floatValue
        calculadora?.numeroFinal = txtSegundoValor.text!.floatValue
        if let calculadora = calculadora as? Porcentagem {
            print(calculadora.calcularDiminuicaoPercentual())
        }
    }
    
    @IBAction func calcularValorInicial(sender: UIButton) {
        //Valor inicial com aumento
        calculadora?.numeroFinal = txtPrimeiroValor.text!.floatValue
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtSegundoValor.text!.floatValue
            if (true) {
                print(calculadora.calcularValorInicialAumentado())
            } else {
                print(calculadora.calcularValorInicialDiminuido())
            }
        }
    }
    
    @IBAction func calcularJurosDescontos(sender: UIButton) {
        //Juros
        calculadora?.numeroAtual = 1000
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = 15
            print(calculadora.calcularValorComJuros())
        }
        
        //Desconto
        calculadora?.numeroAtual = 1000
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = 15
            print(calculadora.calcularValorComDesconto())
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
