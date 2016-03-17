//
//  ContasTableViewController.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

protocol ContasViewControllerDelegate: class {
    func contasViewControllerResponse(conta: Conta)
}

class ContasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

//    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    weak var delegate: ContasViewControllerDelegate?
    
    // Variável de escape para verificar se está vindo da tela ReceitaViewController
    var telaReceita: Bool = false
    let context = ContextFactory.getContext()
    var frc = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        frc = getFetchedResultsController()
        frc.delegate = self
        

        
        do{
            try frc.performFetch()
        }catch{
            let alert = Notification.mostrarErro()
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Core Data source
    func contasFetchRequest() -> NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "Conta")
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "tipoconta.nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor, secondarySortDescriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        
        frc = NSFetchedResultsController(fetchRequest: contasFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "tipoconta.nome", cacheName: nil)
        
        return frc
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if let sections = frc.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        if let sections = frc.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let cell: PlaceContaTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PlaceContaTableViewCell
        // Configure the cell...
        let conta = frc.objectAtIndexPath(indexPath) as! Conta

        cell.txtConta?.text = conta.nome
        cell.txtTipConta.text = String(conta.tipoconta!.valueForKey("nome")!)
        if let saldo = conta.saldo?.floatValue {
            cell.txtSaldo.text = conta.moeda(saldo)
        }
        
//        cell.textLabel?.text = conta.nome
//        cell.detailTextLabel?.text = conta.moeda(Float(conta.saldo!))
            //String("R$ \(conta.saldo!)")
        
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
//            let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
//            
//            // Método para ser chamado ao deletar item
//            func removerSelecionado(action:UIAlertAction){
//                do{
//                    context.deleteObject(managedObject)
//                    try context.save()
//                }catch{
//                    let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível remover")
//                    presentViewController(alert, animated: true, completion: nil)
//                }
//            }
//            
//            let detalhes = UIAlertController(title: "Deletar", message: "Tem certeza que deseja deletar?", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
//            detalhes.addAction(cancelar)
//            
//            let deletar = UIAlertAction(title: "Deletar", style: UIAlertActionStyle.Destructive, handler: removerSelecionado)
//            detalhes.addAction(deletar)
//            
//            presentViewController(detalhes, animated: true, completion: nil)
            
            
            
            
            
            let conta = frc.objectAtIndexPath(indexPath) as! Conta
            
            // Método para ser chamado ao deletar item
            func removerSelecionado(action:UIAlertAction){
                do{
                    context.deleteObject(conta)
                    try context.save()
                }catch{
                    presentViewController(Notification.mostrarErro(), animated: true, completion: nil)
                }
            }
            
            // Verifica se tem alguma receita associada, se não tiver permite deletarß
            if (conta.receita?.count > 0){
                let alerta = Notification.mostrarErro("Desculpe", mensagem: "Você não pode deletar porque há uma ou mais receitas associadas.")
                presentViewController(alerta, animated: true, completion: nil)
            }else{
                
                let detalhes = UIAlertController(title: "Deletar", message: "Tem certeza que deseja deletar?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
                detalhes.addAction(cancelar)
                
                let deletar = UIAlertAction(title: "Deletar", style: UIAlertActionStyle.Destructive, handler: removerSelecionado)
                detalhes.addAction(deletar)
                
                presentViewController(detalhes, animated: true, completion: nil)
                
            }
            
            
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let conta = frc.objectAtIndexPath(indexPath) as! Conta
            delegate?.contasViewControllerResponse(conta)
        
        if telaReceita == true{
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
//    func mostrarErro(titulo: String = "Desculpe", mensagem: String = "Erro inesperado"){
//        
//        let detalhes = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let cancelar = UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil)
//        detalhes.addAction(cancelar)
//        
//        presentViewController(detalhes, animated: true, completion: nil)
//        
//    }

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

    // MARK: - Navigation
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "editar"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let contaController : ContaViewController = segue.destinationViewController as! ContaViewController
            let conta: Conta = frc.objectAtIndexPath(indexPath!) as! Conta
            contaController.conta = conta
        }
        
    
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
