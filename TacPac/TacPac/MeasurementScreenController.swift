//
//  MeasurementScreenController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/9/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class MeasurementViewController: ViewController {
    
    @IBOutlet weak var measurementTextField: UITextField!
    
    @IBOutlet var mainView: UIView!
    
    @IBAction func uploadButtonPress(_ sender: Any) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let result = formatter.string(from: date)
        
        //TODO make sure only number are typed
        let measurement = TacMeasurement(concentration: Double(measurementTextField.text!)!, time:result)
        
        
        //loading opverlay while data is being uploaded
        mainView = UIView(frame: view.frame)
        mainView!.backgroundColor = UIColor.black
        mainView!.alpha = 0.8
        
        view.addSubview(mainView!)
        
        TacPacServer.uploadMeasurement(measurement, completion: {
            (httCode) in
            
            DispatchQueue.main.async {
                if httCode == 200 {
                    //remove loacding overlay
                    self.mainView?.removeFromSuperview()
                    //remove text
                    self.measurementTextField.text = ""
                } else {
                    let alert = UIAlertController(title: "Error", message: "Error Uploading Measurement!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        })
        
        
        
    }
    
    
}
