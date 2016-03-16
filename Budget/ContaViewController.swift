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
    
    @IBAction func maskTextField(sender: UITextField) {
        if var textField = sender.text {
            let char = textField.substringFromIndex((textField.endIndex.predecessor()))
            
            switch char {
            case "0","1","2","3","4","5","6","7","8","9":
                textField = formatCurrency(textField)
                print(textField)
                break;
            default:
                if (char == "") {
                    textField.removeAtIndex(textField.endIndex.predecessor())
                }
                break;
            }
            sender.text = textField
//        print(char
        }
//        print(sender.text)
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
//        
//        textField.text?.appendContentsOf(string)
//        print(textField.text)
//        
//        switch string {
//        case "0","1","2","3","4","5","6","7","8","9":
//            textField.text?.appendContentsOf(string)
//            
//            break;
//        default:
//            if ((string == "") && (textField.text != nil)) {
//                textField.text?.removeAtIndex(textField.text!.endIndex.predecessor())
//            }
//            break;
//        }
//        
////        let numberFromField = textField.text!.floatValue/100
////        textField.text = numberFromField.convertToMoedaBr()
//        
//        return false
//    }
    
    func formatCurrency(string: String) -> String{
//        let formatter = NSNumberFormatter()
//        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
//        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        
        var numberFromField1 = string
        if ((string.rangeOfString("R$") != nil && string.rangeOfString(",") != nil)){
            numberFromField1.removeRange(string.rangeOfString("R$")!)
//            numberFromField1.removeRange(string.rangeOfString(".")!)
            numberFromField1.removeAtIndex((string.rangeOfString(",")?.startIndex)!)
            print(numberFromField1)
            return numberFromField1.floatConverter.convertToMoedaBr()
        }
        
        let numberFromField = string.floatValue/100
        return numberFromField.convertToMoedaBr()
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
