//
//  LoginViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class LoginViewController: ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var lastSelectedTextField:UITextField?
    
    @IBAction func loginButton(_ sender: Any) {
        
        //error correction
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: usernameTextField.text!) && !passwordTextField.text!.isEmpty {
            
            TacPacServer.login(username: usernameTextField.text!, password: passwordTextField.text!, completionHandler: {
                (error) in
                
                DispatchQueue.main.async {
                    //adds to mainthread queue
                    if error != nil {
                        //creates dialog
                        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        //instantiate controller
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let vs = story.instantiateInitialViewController()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = vs
                    }
                }
            })
            
            
        } else {
            print("Invalid input")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        lastSelectedTextField = textField
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            var fieldLocation = lastSelectedTextField!.frame.origin.y + lastSelectedTextField!.frame.height
            
            var kLocation = self.view.frame.height - keyboardSize.height
            
            print("field - \(fieldLocation) ---- keyboard \(kLocation)")
            
            self.view.frame.origin.y = 0
            
            if fieldLocation > kLocation {
                print("Moving!")
                self.view.frame.origin.y -= fieldLocation - kLocation + lastSelectedTextField!.frame.height
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(self.view.frame.origin)
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
 
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
}
