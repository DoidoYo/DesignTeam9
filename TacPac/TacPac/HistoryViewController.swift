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

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var segmentedButtons: UISegmentedControl!
    
    @IBOutlet weak var barView: BarChartView!
    
    @IBAction func exportButtonPress(_ sender: Any) {
        
    }
    
    var measurements : [TacMeasurement] = [TacMeasurement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TacPacServer.getMeasurements(amount: 7, completion: {
            measurements, error in
            
            print("Data Acquired!")
            
            if let err = error {
                print(err)
            }
            
            if let mea = measurements {
                self.measurements = mea
                if self.measurements.count > 0 {
                    self.updateChartWithData()
                }
            }
            
            
        })
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
    
}




