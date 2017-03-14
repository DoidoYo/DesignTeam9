//
//  SignupViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: ViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBAction func birthdayStartEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
    }
    @IBAction func backButtonPress(_ sender: Any) {
        
    }
    @IBAction func signupButton(_ sender: Any) {
        TacPacServer.signup(username: emailTextField.text!, password: passwordTextField.text!, firstName: firstnameTextField.text!, lastName: lastnameTextField.text!, birthday: birthdayTextField.text!, completion: {
            httpCode, msg in
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayTextField.text = dateFormatter.string(from: sender.date)
    }
    
}
