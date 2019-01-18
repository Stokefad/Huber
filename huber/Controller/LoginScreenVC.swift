//
//  LoginScreenVC.swift
//  huber
//
//  Created by Igor-Macbook Pro on 16/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginScreenVC : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "backFromLogin", sender: self)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if result != nil {
                    self.email = email
                    self.performSegue(withIdentifier: "goToMap", sender: self)
                }
                else {
                    print("Error with signing in occured \(String(describing: error))")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! MapViewVC
        
        if let text = email {
            destVC.currentUser = text
        }
    }
    
}
