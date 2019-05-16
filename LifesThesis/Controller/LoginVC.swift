//
//  LoginVC.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/11/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var createUserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 10
        createUserBtn.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTxt.text,
        let password = passwordTxt.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                debugPrint("Error signing in: \(error)")
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
}
