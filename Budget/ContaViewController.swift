//
//  ContasViewController.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ContaViewController: UIViewController, TipoContasViewControllerDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var conta: Conta? = nil
    var tipoConta: TipoConta? = nil
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtSaldo: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let conta = conta {
            txtNome.text = conta.nome!
            txtSaldo.text = String(conta.saldo!)
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
        let context = self.context
        let contaEntity = NSEntityDescription.entityForName("Conta", inManagedObjectContext: context)
        let newConta = NSManagedObject(entity: contaEntity!, insertIntoManagedObjectContext: context)

        
        newConta.setValue(txtNome.text, forKey: "nome")
        newConta.setValue(Float(txtSaldo.text!), forKey: "saldo")
        newConta.setValue(tipoConta, forKey: "tipoconta")
        
        do{
            try newConta.managedObjectContext?.save()
        }catch{
            print(error)
        }
    }
    
    func updateConta(){
        
        conta?.nome = txtNome.text
        conta?.saldo = Float(txtSaldo.text!)
        
        if let tipoConta = tipoConta {
            conta?.tipoconta? = tipoConta
        }
        
        do{
            try self.context.save()
        }catch{
            print(error)
        }
    }
    
    
    // Define Delegate Method
    func tipoContasViewControllerResponse(tipoConta: TipoConta) {
        self.tipoConta = tipoConta
        txtTipo.text = tipoConta.nome
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
            tipoContasController.conta = self.conta
            tipoContasController.delegate = self
        }
        
    }
}
