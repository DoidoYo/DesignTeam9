//
//  ExportViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/24/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class ExportViewController: UIViewController {
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendTapped))
    }
    
    func sendTapped() {
        TacPacServer.export(email: emailTextField.text!, completion: {
            err in
            DispatchQueue.main.async {
                if let e = err {
                    
                    let alert = UIAlertController(title: "Error", message: e, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                self.emailTextField.text = ""
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
