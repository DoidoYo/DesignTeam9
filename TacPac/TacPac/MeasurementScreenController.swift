//
//  MeasurementScreenController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/9/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class MeasurementViewController: ViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var measurementTextField: UITextField!
    
    @IBOutlet var mainView: UIView!
    
    @IBAction func uploadButtonPress(_ sender: Any) {
        self.measurementTextField.resignFirstResponder()
        if let text = measurementTextField.text, text != "" {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let result = formatter.string(from: date)
            
            //TODO make sure only number are typed
            let measurement = TacMeasurement(concentration: Double(text)!, time:result)
            
            startAnimating(CGSize(width: 40, height: 40), message: "Uploading", type: NVActivityIndicatorType(rawValue: 8)!)
            
            TacPacServer.uploadMeasurement(measurement, completion: {
                (httCode) in
                
                DispatchQueue.main.async {
                    //remove loacding overlay
                    self.stopAnimating()
                    if httCode == 200 {
                        //remove text
                        self.measurementTextField.text = ""
                        //check mark animation TODO---------
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Error Uploading Measurement!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            })
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
}
