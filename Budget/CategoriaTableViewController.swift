//
//  CategoriaTableViewController.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

protocol CategoriaViewControllerDelegate: class {
    func categoriaViewControllerResponse(categoria:Categoria)
}

class CategoriaTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    weak var delegate: CategoriaViewControllerDelegate?
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var frc = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frc = getFetchedResultsController()
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }catch{
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Core Data source
    func tipoContasFetchRequest() -> NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "Categoria")
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        
        frc = NSFetchedResultsController(fetchRequest: tipoContasFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numbersOfSections = frc.sections?.count
        return numbersOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRowsInSection = frc.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let categoria = frc.objectAtIndexPath(indexPath) as! Categoria
        delegate?.categoriaViewControllerResponse(categoria)
        navigationController?.popViewControllerAnimated(true)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellCategoria", forIndexPath: indexPath)
        
        // Configure the cell...
        let categoria = frc.objectAtIndexPath(indexPath) as! Categoria
        cell.textLabel?.text = categoria.nome
        
        
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
            
            let categoria = frc.objectAtIndexPath(indexPath) as! Categoria
            
            // Método para ser chamado ao deletar item
            func removerSelecionado(action:UIAlertAction){
                do{
                    context.deleteObject(categoria)
                    try context.save()
                }catch{
                    presentViewController(Notification.mostrarErro(), animated: true, completion: nil)
                }
            }
            
            // Verifica se tem alguma conta associada, se não tiver permite deletarß
            if (categoria.receita?.count > 0){
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
