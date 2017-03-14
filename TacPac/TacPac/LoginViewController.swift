//
//  LoginViewController.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class LoginViewController: ViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        
        
        
    }
 
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
}
