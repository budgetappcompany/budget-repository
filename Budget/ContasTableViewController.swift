//
//  ContasTableViewController.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ContasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

//    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
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
            print(error)
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
        fetchRequest.sortDescriptors = [sortDescriptor]
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
        let numberOfSections = frc.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRowsInSection = frc.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let conta = frc.objectAtIndexPath(indexPath) as! Conta

        
        cell.textLabel?.text = conta.nome
        cell.detailTextLabel?.text = conta.moeda(Float(conta.saldo!))
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
            
            let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
            context.deleteObject(managedObject)
            
            do{
                try context.save()
            }catch{
                print(error)
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
