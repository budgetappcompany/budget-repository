//
//  ReceitasTableViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/16/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ReceitasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{


    var tabBar: UITabBar?
    var frc = NSFetchedResultsController()
    let receitaDAO = ReceitaDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frc = Receita.getReceitasController("nome", secondSort: "data", sectionName: "data")
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }catch{
            let alert = Notification.mostrarErro()
            presentViewController(alert, animated: true, completion: nil)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = frc.sections {
            let currentSection = sections[section]
            return Data.sectionFormatarData(currentSection.name)
        }
        
        return nil
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PlaceReceitaTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellReceita", forIndexPath: indexPath) as! PlaceReceitaTableViewCell
        
        // Configure the cell...
        let receita = frc.objectAtIndexPath(indexPath) as! Receita
        cell.lblNome.text = receita.nome
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 14)!
        header.textLabel?.textColor = Color.uicolorFromHex(0x44a499)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Color.uicolorFromHex(0xffffff)
        }else{
            cell.backgroundColor = Color.uicolorFromHex(0xf4f4f4)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
//        
//        let valorReceita = managedObject.valueForKey("valor")
//        let valorConta = managedObject.valueForKey("conta")
//        
//        print("\(valorReceita) \(valorConta)")
//        
//    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let detalhes = Notification.solicitarConfirmacao("Excluir", mensagem: "Tem certeza que deseja excluir?", completion:{
                (action:UIAlertAction) in
                do{
                    let receita:Receita = self.frc.objectAtIndexPath(indexPath) as! Receita
                    try self.receitaDAO.remover(receita)
                } catch {
                    let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível remover")
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
            presentViewController(detalhes, animated: true, completion: nil)
            
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
            let contaController : ReceitasViewController = segue.destinationViewController as! ReceitasViewController
            let receita: Receita = frc.objectAtIndexPath(indexPath!) as! Receita
            contaController.receita = receita
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
/*==========================================================================================

let context = ContextFactory.getContext()

//Personalizar TabBar
//É necessário colocar na table inicial para mudar em todas.
tabBar = self.tabBarController!.tabBar
CustomTabBar.custom(&tabBar!)

// MARK: - Core Data source
func contasFetchRequest() -> NSFetchRequest{
    let fetchRequest = NSFetchRequest(entityName: "Receita")
    let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
    let sortDescriptor1 = NSSortDescriptor(key: "data", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor1]
    return fetchRequest
}

func getFetchedResultsController() -> NSFetchedResultsController {

    frc = NSFetchedResultsController(fetchRequest: contasFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "data", cacheName: nil)

    return frc
}

sections[section]

let string = currentSection.name.substringWithRange(Range<String.Index>(start: currentSection.name.startIndex, end: currentSection.name.startIndex.advancedBy(10)))

let dateFormat = NSDateFormatter()
dateFormat.dateFormat = "yyyy-MM-dd"
let ddd = dateFormat.dateFromString(string)

dateFormat.dateStyle = NSDateFormatterStyle.LongStyle
dateFormat.timeStyle = NSDateFormatterStyle.NoStyle
dateFormat.locale = NSLocale(localeIdentifier: "pt-BR")

let dateString = dateFormat.stringFromDate(ddd!)

if let sections = frc.sections {
    let currentSection = sections[section]
    return currentSection.name
}

let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

cell.textLabel?.text = receita.nome

cell.txtConta?.text = conta.nome
cell.txtTipConta.text = String(conta.tipoconta!.valueForKey("nome")!)
cell.txtSaldo.text = conta.moeda(Float(conta.saldo!))

cell.textLabel?.text = conta.nome
cell.detailTextLabel?.text = conta.moeda(Float(conta.saldo!))
String("R$ \(conta.saldo!)")

// Delete the row from the data source
let receita : Receita = frc.objectAtIndexPath(indexPath) as! Receita

// Pega o valor da receita e o saldo da conta.
let valorReceita = receita.valueForKey("valor")
let valorConta = receita.conta!.valueForKey("saldo")

// Subtrai o saldo da conta pelo valor da receita
let saldoAtualConta = valorConta!.floatValue - valorReceita!.floatValue



// Método para ser chamado ao deletar item
func removerSelecionado(action:UIAlertAction){
do{
receita.managedObjectContext?.deleteObject(receita)

// Atualiza o saldo da conta removendo o valor da receita que estava cadastrada
receita.conta!.setValue(saldoAtualConta, forKey: "saldo")

try receita.managedObjectContext?.save()
}catch{
let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível remover")
presentViewController(alert, animated: true, completion: nil)
}
}

let detalhes = UIAlertController(title: "Deletar", message: "Tem certeza que deseja deletar? \n O salda da sua conta será atualizado!", preferredStyle: UIAlertControllerStyle.Alert)

let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
detalhes.addAction(cancelar)

let deletar = UIAlertAction(title: "Deletar", style: UIAlertActionStyle.Destructive, handler: removerSelecionado)
detalhes.addAction(deletar)
==========================================================================================*/
