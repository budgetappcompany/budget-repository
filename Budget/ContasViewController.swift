//
//  ContasViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ContasViewController: UITableViewController, TipoContasViewControllerDelegate, UITextFieldDelegate {
    
    
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
            case "-":
                
                if(textField != "-" && textField.floatValue != 0){
                    textField.removeAtIndex(textField.endIndex.predecessor())
                    textField = formatCurrency(textField)
                } else {
                    
                    textField = formatCurrency("-1")
                    print(textField)
                }
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
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var navegacao: UINavigationItem!
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
            navegacao.title = "Alterar"
        }
        
        txtTipo.text = tipoConta?.nome
        
        updateWidthsForLabels(labels)
        
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
            navigationController?.popViewControllerAnimated(true)
        }else{
            addConta()
            dissmissViewController()
        }
        
        
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
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível registrar")
            presentViewController(alert, animated: true, completion: nil)
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
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível atualizar")
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    // Define Delegate Method
    func tipoContasViewControllerResponse(tipoConta: TipoConta) {
        self.tipoConta = tipoConta
        txtTipo.text = tipoConta.nome
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0: return 2    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    private func calculateLabelWidth(label: UILabel) -> CGFloat {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.max, height: label.frame.height))
        
        return labelSize.width
    }
    
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
//        return reduce(map(labels, calculateLabelWidth), 0, max)
        return labels.map(calculateLabelWidth).reduce(0, combine: max)
    }
    
    private func updateWidthsForLabels(labels: [UILabel]) {
        let maxLabelWidth = calculateMaxLabelWidth(labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: maxLabelWidth)
            label.addConstraint(constraint)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "alterarTipoConta"{
            let tipoContasController : TipoContasTableViewController = segue.destinationViewController as! TipoContasTableViewController
            tipoContasController.delegate = self
        }
        
    }

}
