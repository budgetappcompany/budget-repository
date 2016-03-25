//
//  DashboardViewController.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import Charts

extension NSDate {
    
    func startOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components([.Month, .Year], fromDate: self)
        let startOfMonth = calendar.dateFromComponents(currentDateComponents)
        
        return startOfMonth
    }
    
    func dateByAddingMonths(monthsToAdd: Int) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let months = NSDateComponents()
        months.month = monthsToAdd
        
        return calendar.dateByAddingComponents(months, toDate: self, options: [])
    }
    
    func endOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateByAddingUnit(.Day, value: -1, toDate: self.dateByAddingMonths(1)!, options: [])
        
//        return nil
    }
}

class DashboardViewController: UIViewController {

    @IBOutlet weak var lblBalancoTotal: UILabel!
    @IBOutlet weak var lblTotalDespesas: UILabel!
    @IBOutlet weak var lblTotalReceitas: UILabel!
    @IBOutlet var btnMenuSidebar: UIBarButtonItem!
    @IBOutlet var lineChart: LineChartView!
//    var zoom:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Dashboard.getTotalBalanco()
        
        lblBalancoTotal.text = Dashboard.getTotalBalanco().convertToMoedaBr()
        lblTotalReceitas.text = Dashboard.getTotalReceitas().convertToMoedaBr()
        lblTotalDespesas.text = "R$0,00"
        
        btnMenuSidebar.target = self.revealViewController()
        btnMenuSidebar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let (balanco, months) = Dashboard.getBalancoAnual()
        setChart(months, values: balanco)
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        lineChart.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let dataSet = LineChartDataSet(yVals: dataEntries, label: "Balanço")
        let data = LineChartData(xVals: dataPoints, dataSet: dataSet)
        
        dataSet.colors = [UIColor.whiteColor()]
        dataSet.lineWidth = 3
        dataSet.circleRadius = 5
        dataSet.circleColors = [Color.uicolorFromHex(0x9ee9e1)]
        dataSet.drawCircleHoleEnabled = false
        
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseOutCirc)
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.leftYAxisRenderer.yAxis?.enabled = false
        lineChart.descriptionText = ""
        lineChart.legend.enabled = false
        lineChart.rightYAxisRenderer.yAxis?.enabled = false
        lineChart.leftYAxisRenderer.yAxis?.drawGridLinesEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.sizeToFit()
        lineChart.drawMarkers = false
        lineChart.drawGridBackgroundEnabled = false
        lineChart.data = data
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
