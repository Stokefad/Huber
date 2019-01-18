//
//  RegisterScreenVC.swift
//  huber
//
//  Created by Igor-Macbook Pro on 17/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterScreenVC : UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "backFromRegistrationToLogin", sender: self)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let name = nameTF.text, let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                self.performSegue(withIdentifier: "backFromRegistration", sender: self)
                if result != nil {
                    Firestore.firestore().collection("users").document(email).setData([
                        "name" : name,
                        "email" : email,
                    ])
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = MapViewVC()
        
        if segue.identifier == "backFromRegistration" {
            if let email = emailTF.text {
                destVC.currentUser = email
            }
        }
    }
    
}
