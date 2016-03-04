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
    var intValue: Int {
        return (self as NSString).integerValue
    }
}

extension Float {
    var stringValue: String {
        return String(format: "%g", self)
    }
}

class CalculadoraController: UIViewController {

    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var lblOperador: UILabel!
    @IBOutlet weak var lblVisor: UILabel!
    var teste:String? = nil
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
        if((calculadora?.numeroAtual == 0) && (!(lblVisor.text!.containsString("."))) && lblVisor.text != "-"){
            lblVisor.text = sender.currentTitle
        } else {
            lblVisor.text?.appendContentsOf(sender.currentTitle!)
        }
        if (lblVisor.text!.floatValue != 0) {
            calculadora?.numeroAtual = lblVisor.text!.floatValue
        }
    }
    
    @IBAction func inserirDecimal(sender: UIButton) {
        print(lblVisor.text!.containsString("."))
        if (!(lblVisor.text!.containsString("."))) {
            lblVisor.text?.appendContentsOf(".")
        }
    }

    @IBAction func inserirOperacao(sender: UIButton) {
        if(sender.currentTitle == "-" && calculadora?.numeroAtual == 0){
            lblVisor.text = sender.currentTitle!
        }else{
            if(calculadora?.resultadoOp == 0){
                calculadora?.resultadoOp = calculadora!.numeroAtual
                lblResultado.text = calculadora!.resultadoOp.stringValue
            } else {
                lblResultado.text = calculadora!.calcularOperacao().stringValue
            }
            lblVisor.text = "0"
            lblOperador.text = sender.currentTitle
            calculadora?.opcao = sender.tag
            calculadora?.numeroAtual = 0
        }
    }
    
    @IBAction func realizarOperacao(sender: UIButton) {
        lblVisor.text = calculadora!.calcularOperacao().stringValue
        calculadora?.numeroAtual = lblVisor.text!.floatValue
        calculadora?.resultadoOp = 0
        lblResultado.text = ""
        lblOperador.text = ""
    }
    
    @IBAction func limparVisor(sender: UIButton) {
        calculadora?.numeroAtual = 0
        calculadora?.resultadoOp = 0
        lblResultado.text = ""
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
