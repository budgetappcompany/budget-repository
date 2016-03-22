//
//  DespesaViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/19/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class DespesaViewController: UIViewController, ContasViewControllerDelegate, CategoriaViewControllerDelegate {
    
    var conta: Conta? = nil
    var categoria: Categoria? = nil
    var despesa: Despesa?
    
    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var navegacao: UINavigationItem!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtConta: UITextField!
    @IBOutlet weak var txtCategoria: UITextField!
    @IBOutlet weak var sgFglTipo: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let despesa = despesa {
            txtNome.text = despesa.nome!
            txtValor.text = String(despesa.valor!)
            txtEndereco.text = despesa.endereco!
            txtDescricao.text = despesa.descricao!
            pickerView.setDate(despesa.data!, animated: false)
            conta = despesa.conta as? Conta
            categoria = despesa.categoria as? Categoria
            sgFglTipo.selectedSegmentIndex = Int(despesa.flgTipo!)!
            navegacao.title = "Alterar despesa"
        }
        
        txtConta.text = self.conta?.nome!
        txtCategoria.text = self.categoria?.nome!

        // Do any additional setup after loading the view.
    }
    
    func dissmissViewController(){
        navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if despesa != nil {
            updateConta()
        }else{
            addConta()
            
        }  
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl){
        switch sgFglTipo.selectedSegmentIndex{
            case 0:
                despesa?.flgTipo = "0"; // Fixa
            case 1:
                despesa?.flgTipo = "1"; // Variável
            case 2:
                despesa?.flgTipo = "2" // Adicional
            default:
                break;
    }
    
    }
    
    func addConta(){
        
        despesa = Despesa.getDespesa()
        despesa?.nome = txtNome.text
        despesa?.descricao = txtDescricao.text
        despesa?.valor = Float(txtValor.text!)
        despesa?.endereco = txtEndereco.text
        despesa?.conta = conta
        despesa?.categoria = categoria
        despesa?.data = pickerView.date
        
        indexChanged(sgFglTipo)
        
        // Atualizar o saldo da conta referente
        conta?.saldo = Float((conta?.saldo)!) - Float((despesa?.valor)!)
        
        do{
            try despesa?.managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
        }catch{
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível registrar")
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func updateConta(){
        
        despesa?.nome = txtNome.text
        despesa?.valor = Float(txtValor.text!)
        despesa?.endereco = txtEndereco.text
        despesa?.descricao = txtDescricao.text
        despesa?.data = pickerView.date
        
        indexChanged(sgFglTipo)
        
        if let conta = conta {
            despesa?.conta? = conta
        }
        
        if let categoria = categoria{
            despesa?.categoria = categoria
        }
        
        do{
            try despesa?.managedObjectContext?.save()
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
    
    func categoriaViewControllerResponse(categoria:Categoria){
        self.categoria = categoria
        txtCategoria.text = categoria.nome
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
        }else if segue.identifier == "alterarCategoriaDespesa"{
            let categoriasController : CategoriaTableViewController = segue.destinationViewController as! CategoriaTableViewController
            categoriasController.delegate = self
            
        }
        
    }

}
