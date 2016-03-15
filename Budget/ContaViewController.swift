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
    
//    let context = ContextFactory.getContext()
    
    var conta: Conta?
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
//        let context = self.context
//        let contaEntity = NSEntityDescription.entityForName("Conta", inManagedObjectContext: context)
        
        conta = Conta.getConta()
        conta?.nome = txtNome.text
        conta?.saldo = Float(txtSaldo.text!)
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
        conta?.saldo = Float(txtSaldo.text!)
        
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
