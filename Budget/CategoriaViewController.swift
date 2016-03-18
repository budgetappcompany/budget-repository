//
//  CategoriaViewController.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class CategoriaViewController: UIViewController {

    var categoria: Categoria?
    
    @IBOutlet weak var txtNome: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let categoria = categoria{
            txtNome.text = categoria.nome!
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
        //        let context = self.context
        //        let tipoContaEntity = NSEntityDescription.entityForName("TipoConta", inManagedObjectContext: context)
        //        let newTipoConta = NSManagedObject(entity: tipoContaEntity!, insertIntoManagedObjectContext: context)
        
        categoria = Categoria.getCategoria()
        
        //        tipoConta.setValue(txtNome.text, forKey: "nome")
        
        categoria?.nome = txtNome.text
        do{
            try categoria?.managedObjectContext?.save()
        }catch{
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível registrar")
            presentViewController(alert, animated: true, completion: nil)
        }
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
