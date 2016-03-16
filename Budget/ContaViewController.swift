//
//  ContasViewController.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ContaViewController: UIViewController, TipoContasViewControllerDelegate, UITextFieldDelegate {
    
//    let context = ContextFactory.getContext()
    
    
    
    @IBOutlet weak var textField: UITextField!
    var currentString = ""
    
    //Textfield delegates
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//
//    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count
//        let currentCharacterCount = textField.text?.characters.count ?? 0
//        if (range.length + range.location > currentCharacterCount){
//            return false
//        }
        let newLength = currentCharacterCount! + string.characters.count - range.length
        return newLength <= 14
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        if var textField = sender.text {
            
            textField = formatText(textField)
            let char = textField.substringFromIndex((textField.endIndex.predecessor()))
            switch char {
            case "0","1","2","3","4","5","6","7","8","9":
                textField = formatCurrency(textField)
//                print(textField)
                break;
            default:
                textField.removeAtIndex(textField.endIndex.predecessor())
                textField = formatCurrency(textField)
            }
            sender.text = textField
//        print(char
        }
//        print(sender.text)
    }
    
    func formatText(var priceS: String) -> String{
        priceS = priceS.stringByReplacingOccurrencesOfString("R$",withString:"")
//        priceS = priceS.stringByReplacingOccurrencesOfString(",00",withString:"")
        priceS = priceS.stringByReplacingOccurrencesOfString(".",withString:"")
        priceS = priceS.stringByReplacingOccurrencesOfString(",",withString:"")
        return priceS
    }
    
    func formatCurrency(string: String) -> String{
        
//3        var numberFromField1 = string
//        if ((string.rangeOfString("R$") != nil && string.rangeOfString(",") != nil)){
//            numberFromField1.removeRange(string.rangeOfString("R$")!)
////            numberFromField1.removeRange(string.rangeOfString(".")!)
//            numberFromField1.removeAtIndex((string.rangeOfString(",")?.startIndex)!)
//            return numberFromField1.floatConverter.convertToMoedaBr()
//        }
        var numberFromField:Float?
//        print(string.floatConverter)
        numberFromField = string.floatConverter/100
        
        return numberFromField!.convertToMoedaBr()
        
    }
    
    var conta: Conta?
    var tipoConta: TipoConta? = nil
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtSaldo: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtSaldo.delegate = self
        
        if let conta = conta {
            txtNome.text = conta.nome!
            if let saldo = conta.saldo?.floatValue{
                txtSaldo.text = saldo.convertToMoedaBr()
            }
            
            tipoConta = conta.tipoconta as? TipoConta
        }
        
        txtTipo.text = tipoConta?.nome
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if conta != nil {
            updateConta()
        }else{
            addConta()
        }
        
        dissmissViewController()
    }
    
    func dissmissViewController(){
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func addConta(){
//        let context = self.context
//        let contaEntity = NSEntityDescription.entityForName("Conta", inManagedObjectContext: context)
        
        conta = Conta.getConta()
        conta?.nome = txtNome.text
        if let saldo = txtSaldo.text?.floatConverterMoeda(){
            conta?.saldo = saldo
        } else {
            Notification.mostrarErro()
        }
        conta?.tipoconta = tipoConta
        
//        conta?.setValue(txtNome.text, forKey: "nome")
//        conta.setValue(Float(txtSaldo.text!), forKey: "saldo")
//        newConta.setValue(tipoConta, forKey: "tipoconta")
        
        do{
            try conta?.managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    func updateConta(){
        
        conta?.nome = txtNome.text
        
        conta?.saldo = txtSaldo.text!.floatConverterMoeda()
        print(txtSaldo.text!.floatConverterMoeda())
        if let tipoConta = tipoConta {
            conta?.tipoconta? = tipoConta
        }
        
        do{
            try conta?.managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    
    // Define Delegate Method
    func tipoContasViewControllerResponse(tipoConta: TipoConta) {
        self.tipoConta = tipoConta
        txtTipo.text = tipoConta.nome
    }
    
    func mostrarErro(titulo: String = "Desculpe", mensagem: String = "Erro inesperado"){
        
        let detalhes = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelar = UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil)
        detalhes.addAction(cancelar)
        
        presentViewController(detalhes, animated: true, completion: nil)
        
    }

    

    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let goNext = segue.destinationViewController as! TipoContasTableViewController
        goNext.delegate = self
    }
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "alterarTipoConta"{
            let tipoContasController : TipoContasTableViewController = segue.destinationViewController as! TipoContasTableViewController
            tipoContasController.delegate = self
        }
        
    }
}
