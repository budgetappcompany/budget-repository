//
//  ReceitasViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ReceitasViewController: UITableViewController, ContasViewControllerDelegate, CategoriaViewControllerDelegate  {

    
    var conta: Conta? = nil
    var categoria: Categoria? = nil
    var receita: Receita?
    let receitaDAO:ReceitaDAO = ReceitaDAO()
    var pickerView: UIDatePicker!
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var navegacao: UINavigationItem!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtConta: UITextField!
    @IBOutlet weak var txtCategoria: UITextField!
    @IBOutlet weak var txtData: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIDatePicker()
        pickerView.datePickerMode = UIDatePickerMode.Date
        pickerView.addTarget(self, action: "updateTextField:", forControlEvents: .ValueChanged)
        
        
        if let receita = receita {
            txtNome.text = receita.nome!
            txtValor.text = String(receita.valor!)
            txtEndereco.text = receita.endereco!
            txtDescricao.text = receita.descricao!
            txtData.text = Data.formatDateToString(receita.data!)
            conta = receita.conta as? Conta
            categoria = receita.categoria as? Categoria
            navegacao.title = "Alterar"
        }
        
        txtConta.text = self.conta?.nome!
        txtCategoria.text = self.categoria?.nome!
        txtData.inputView = pickerView
        
        // Alinhar as labels
        updateWidthsForLabels(labels)

    }
    
    func updateTextField(sende:UIDatePicker){
        txtData.text = Data.formatDateToString(sende.date)
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
        receita?.categoria = categoria

        receita?.data = Data.removerTime(txtData.text!)
        
        // Atualizar o saldo da conta referente
        conta?.saldo = Float((receita?.valor)!) + Float((conta?.saldo)!)
        
        do{
            try receitaDAO.salvar(receita!)
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
        
        
        receita?.data = Data.removerTime(txtData.text!)
        
        
        if let conta = conta {
            receita?.conta? = conta
        }
        
        if let categoria = categoria{
            receita?.categoria = categoria
        }
        
        do{
            try receitaDAO.salvar(receita!)
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0: return 5    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        case 2: return 1    // section 2 has 1 row
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "alterarConta"{
            let contasController : ContasTableViewController = segue.destinationViewController as! ContasTableViewController
            contasController.delegate = self
            contasController.telaReceita = true
        }else if segue.identifier == "alterarCategoriaReceita"{
            let categoriasController : CategoriaTableViewController = segue.destinationViewController as! CategoriaTableViewController
            categoriasController.delegate = self
            
        }
        
    }

}
