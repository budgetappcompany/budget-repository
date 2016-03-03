//
//  CalculadoraController.swift
//  Budget
//
//  Created by md10 on 3/3/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

class CalculadoraController: UIViewController {

    @IBOutlet weak var lblPrimeiroValor: UILabel!
    @IBOutlet weak var lblOperador: UILabel!
    @IBOutlet weak var lblVisor: UILabel!
    var calculadora:Calculadora?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculadora = Calculadora()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inserirNumero(sender: UIButton) {
        if(calculadora?.primeiroValor == 0){
            lblVisor.text = sender.currentTitle
        } else {
            lblVisor.text?.appendContentsOf(sender.currentTitle!)
        }
        calculadora?.primeiroValor = lblVisor.text!.floatValue
    }
    
    @IBAction func inserirDecimal(sender: UIButton) {
    }
    
    func atualizarLabels() {
        calculadora?.segundoValor = calculadora!.primeiroValor
        lblVisor.text = "0"
        lblPrimeiroValor.text = "\(calculadora!.segundoValor)"
        calculadora?.primeiroValor = 0
    }
    
    func limparLabels() {
        calculadora?.primeiroValor = 0;
        calculadora?.segundoValor = 0;
        lblPrimeiroValor.text = ""
        lblOperador.text = ""
    }

    @IBAction func inserirOperacao(sender: UIButton) {
        calculadora?.primeiroValor = lblVisor.text!.floatValue
        lblOperador.text = sender.currentTitle
        calculadora?.opcao = sender.tag
        atualizarLabels()
    }
    
    @IBAction func realizarOperacao(sender: UIButton) {
        lblVisor.text = "\(calculadora!.calcularOperacao())"
        limparLabels()
    }
    
    @IBAction func limparVisor(sender: UIButton) {
        calculadora?.primeiroValor = 0;
        calculadora?.segundoValor = 0;
        lblPrimeiroValor.text = ""
        lblOperador.text = ""
        lblVisor.text = "0"
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
