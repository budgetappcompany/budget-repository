//
//  TipoContasViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class TipoContasViewController: UITableViewController {
    
    var tipoConta: TipoConta?
    var erros: String = ""
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tipoConta = tipoConta{
            txtNome.text = tipoConta.nome!
        }
        
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
        
        addConta()
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func dissmissViewController(){
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func validarCampos(){
        if Validador.vazio(txtNome.text!){
            erros.appendContentsOf("Preencha o campo nome!\n")
        }
    }
    
    func addConta(){

        if (erros.isEmpty){
            tipoConta = TipoConta.getTipoConta()
            tipoConta?.nome = txtNome.text
            
            do{
                try tipoConta?.managedObjectContext?.save()
            }catch{
                let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível registrar")
                presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            let alert = Notification.mostrarErro("Campo vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            erros.removeAll()
        }

    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
