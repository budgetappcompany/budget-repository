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
    
    let contextJS = JSContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            var path = NSBundle.mainBundle().pathForResource("calcs",
                ofType: "js")
            
            var url = NSURL(fileURLWithPath: path!)
            var jscript = try String.init(contentsOfURL: url)
            
            
            contextJS.evaluateScript(jscript)
            
            path = NSBundle.mainBundle().pathForResource("fazaconta-v6",
                ofType: "js")
            
            url = NSURL(fileURLWithPath: path!)
            jscript = try String.init(contentsOfURL: url)
            contextJS.evaluateScript(jscript)
        }catch{
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var calcularJuros: UIButton!

    @IBAction func calcularJuros(sender: AnyObject) {
        let methodTest = contextJS.objectForKeyedSubscript("tucalc2")
        
//        let parc = "6"
//        let prest = "704,28"
//        let vf = "-30.000"
        
        let param:String = "RATE("+txtParcelas.text!+"|"+txtValorParcela.text!+"|"+txtValorFinanciado.text!+")"
        
        lblResultadoJuros.text = methodTest.callWithArguments([param,2, true, "", ""]).toString()
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
