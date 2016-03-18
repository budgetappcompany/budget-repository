//
//  CompraPrazoVistaViewController.swift
//  Budget
//
//  Created by md10 on 3/17/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import JavaScriptCore

class CompraPrazoVistaViewController: UIViewController {

    @IBOutlet weak var txtParcelas: UITextField!
    @IBOutlet weak var txtValorParcela: UITextField!
    @IBOutlet weak var txtValorFinanciado: UITextField!
    @IBOutlet weak var lblResultadoJuros: UILabel!
    
    var finance: Finance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finance = Finance()
//        print(finance.cagr(704.28, 30000, 3))
        print(finance.calculateCompoundInterest(720, 12, 62.5))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var calcularJuros: UIButton!

    @IBAction func calcularJuros(sender: AnyObject) {
//        print(finance.cagr(704.28, 30000, 3))
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
