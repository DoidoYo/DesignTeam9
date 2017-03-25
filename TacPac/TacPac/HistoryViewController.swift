//
//  HistoryViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/9/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedButtons: UISegmentedControl!
    
    @IBOutlet weak var barView: BarChartView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var measurements : [TacMeasurement] = [TacMeasurement]()
    
    @IBAction func exportButtonPress(_ sender: UIButton) {
        
    }
    @IBAction func segmentedButtonPress(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            barView.isHidden = false
            tableView.isHidden = true
        } else {
            barView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        barView.xAxis.enabled = false
        barView.legend.enabled = false
        barView.leftAxis.enabled = false
        barView.rightAxis.enabled = false
        barView.chartDescription?.text = ""
        barView.highlightPerTapEnabled = false
        barView.highlightPerDragEnabled = false
        
        TacPacServer.getMeasurements(amount: 7, completion: {
            measurements, error in
            
            //print("Data Acquired!")
            
            if let err = error {
                print(err)
            }
            
            
            //NOPE
            if let mea = measurements {
                
                for i in mea {
                    if !self.measurements.contains(i) {
                        self.measurements.append(i)
                    }
                }
                
                self.updateChartWithData()
                self.tableView.reloadData()
            }
            
            
        })
    }
    
    @IBAction func unwindToHistory(sender: UIStoryboardSegue)
    {
    }
    
    func updateChartWithData() {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<measurements.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: measurements[i].concentration)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Measurements")
        let chartData = LineChartData(dataSet: chartDataSet)
        barView.data = chartData
        barView.animate(yAxisDuration: 0.1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = String(measurements[measurements.count - 1 - indexPath.row].concentration) + " ng/L"
        cell.detailTextLabel?.text = measurements[measurements.count - 1 - indexPath.row].time
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}




