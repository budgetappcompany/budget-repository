//
//  DespesasViewController.swift
//  Budget
//
//  Created by md10 on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class DespesasViewController: UITableViewController, ContasViewControllerDelegate, CategoriaViewControllerDelegate  {
    
    var conta: Conta? = nil
    var categoria: Categoria? = nil
    var despesa: Despesa?
    var pickerView: UIDatePicker!
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var navegacao: UINavigationItem!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtConta: UITextField!
    @IBOutlet weak var txtCategoria: UITextField!
    @IBOutlet weak var sgFglTipo: UISegmentedControl!
    @IBOutlet weak var txtData: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIDatePicker()
        pickerView.datePickerMode = UIDatePickerMode.Date
        pickerView.addTarget(self, action: "updateTextField:", forControlEvents: .ValueChanged)
        
        if let despesa = despesa {
            txtNome.text = despesa.nome!
            txtValor.text = String(despesa.valor!)
            txtEndereco.text = despesa.endereco!
            txtDescricao.text = despesa.descricao!
            conta = despesa.conta as? Conta
            txtData.text = Data.formatDateToString(despesa.data!)
            categoria = despesa.categoria as? Categoria
            sgFglTipo.selectedSegmentIndex = Int(despesa.flgTipo!)!
            navegacao.title = "Alterar"
        }
        
        txtConta.text = self.conta?.nome!
        txtCategoria.text = self.categoria?.nome!
        txtData.inputView = pickerView
        
        // Alinhar as labels
        updateWidthsForLabels(labels)
        
        // Do any additional setup after loading the view.
    }
    
    func updateTextField(sende:UIDatePicker){
        
        txtData.text = Data.formatDateToString(sende.date)
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
        despesa?.data = Data.removerTime(txtData.text!)
        
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
        despesa?.data = Data.removerTime(txtData.text!)
        
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


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0: return 5    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        case 2: return 1    // section 2 has 1 row
        case 3: return 1    // section 3 has 1 row
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
