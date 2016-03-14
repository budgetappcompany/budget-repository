//
//  TipoContaViewController.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class TipoContaViewController: UIViewController {

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var tipoConta: TipoConta?
    
    @IBOutlet weak var txtNome: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tipoConta = tipoConta{
          txtNome.text = tipoConta.nome!
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnCancel(sender: AnyObject) {
        
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
//        if tipoConta != nil {
//            updateConta()
//            
//        }else{
            addConta()
            navigationController?.popViewControllerAnimated(true)
//        }
        
//        dissmissViewController()
    }
    
    func dissmissViewController(){
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func addConta(){
        let context = self.context
        let tipoContaEntity = NSEntityDescription.entityForName("TipoConta", inManagedObjectContext: context)
        let newTipoConta = NSManagedObject(entity: tipoContaEntity!, insertIntoManagedObjectContext: context)
        
        
        newTipoConta.setValue(txtNome.text, forKey: "nome")
        
        do{
            try newTipoConta.managedObjectContext?.save()
            
            
        }catch{
            mostrarErro("Desculpe", mensagem: "Não foi possível registrar")
        }
        
        
    }
    
    func mostrarErro(titulo: String = "Desculpe", mensagem: String = "Erro inesperado"){
        
        let detalhes = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelar = UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil)
        detalhes.addAction(cancelar)
        
        presentViewController(detalhes, animated: true, completion: nil)
        
    }
    
//    func updateConta(){
//        
//        tipoConta?.nome = txtNome.text
//        
//        do{
//            try self.context.save()
//        }catch{
//            print(error)
//        }
//        
//        
//    }
    
    
//    // Define Delegate Method
//    func tipoContasViewControllerResponse(tipoConta: TipoConta) {
//        self.tipoConta = tipoConta
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
