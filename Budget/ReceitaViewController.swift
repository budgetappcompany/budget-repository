//
//  ReceitaViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/16/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ReceitaViewController: UIViewController, ContasViewControllerDelegate {

    var conta: Conta? = nil
    var receita: Receita?
    
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var navegacao: UINavigationItem!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtConta: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let receita = receita {
            txtNome.text = receita.nome!
            txtValor.text = String(receita.valor!)
            txtEndereco.text = receita.endereco!
            txtDescricao.text = receita.descricao!
            pickerView.setDate(receita.data!, animated: false)
            conta = receita.conta as? Conta
            navegacao.title = "Alterar receita"
        }
        
        txtConta.text = self.conta?.nome!
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dissmissViewController(){
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if receita != nil {
            updateConta()
        }else{
            addConta()
            
        }
        
        
    }
    
    func addConta(){
        
        receita = Receita.getReceita()
        receita?.nome = txtNome.text
        receita?.descricao = txtDescricao.text
        receita?.valor = Float(txtValor.text!)
        receita?.endereco = txtEndereco.text
        receita?.conta = conta
        receita?.data = pickerView.date
        
        // Atualizar o saldo da conta referente
        conta?.saldo = Float((receita?.valor)!) + Float((conta?.saldo)!)
        
        do{
            try receita?.managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
        }catch{
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível registrar")
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func updateConta(){
        
        receita?.nome = txtNome.text
        receita?.valor = Float(txtValor.text!)
        receita?.endereco = txtEndereco.text
        receita?.descricao = txtDescricao.text
        receita?.data = pickerView.date
//            NSDateFormatter.localizedStringFromDate(, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
//            NSDateFormatter.
        

        if let conta = conta {
            receita?.conta? = conta
        }
        
        do{
            try receita?.managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
        }catch{
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível atualizar")
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    // Define Delegate Method
    func contasViewControllerResponse(conta: Conta) {
        self.conta = conta
        txtConta.text = conta.nome
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "alterarConta"{
            let contasController : ContasTableViewController = segue.destinationViewController as! ContasTableViewController
            contasController.delegate = self
            contasController.telaReceita = true
        }
        
    }


}
