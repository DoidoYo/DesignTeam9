//
//  ExportViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ExportViewController: UIViewController, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func sendPressed(_ sender: Any) {startAnimating(CGSize(width: 40, height: 40), message: "Sending Data", type: NVActivityIndicatorType(rawValue: 8)!)
        emailTextField.resignFirstResponder()
        
        TacPacServer.export(email: emailTextField.text!, completion: {
            err in
            DispatchQueue.main.async {
                self.stopAnimating()
                self.emailTextField.text = ""
                if let e = err {
                    self.emailTextField.becomeFirstResponder()
                    let alert = UIAlertController(title: "Error", message: e, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailTextField.resignFirstResponder()
    }
}
