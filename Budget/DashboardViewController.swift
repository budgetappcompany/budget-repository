//
//  DashboardViewController.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var lblBalancoTotal: UILabel!
    @IBOutlet weak var lblTotalDespesas: UILabel!
    @IBOutlet weak var lblTotalReceitas: UILabel!
    @IBOutlet var btnMenuSidebar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Dashboard.getTotalBalanco()
        
        lblBalancoTotal.text = Dashboard.getTotalBalanco().convertToMoedaBr()
        lblTotalReceitas.text = Dashboard.getTotalReceitas().convertToMoedaBr()
        lblTotalDespesas.text = "R$0,00"
        
        btnMenuSidebar.target = self.revealViewController()
        btnMenuSidebar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    override func viewWillAppear(animated: Bool) {
        self.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
