//
//  CreateUserVC.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/11/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import Firebase

class CreateUserVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    

    @IBAction func createTapped(_ sender: UIButton) {
        guard let email = emailTxt.text,
            let password = passwordTxt.text,
            let username = usernameTxt.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                debugPrint("Error creating user: \(error.localizedDescription)")
            }
            guard let user = authResult?.user else { return }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                Firestore.firestore().collection(USERS_REF).document(user.uid).setData([
                    USERNAME : username,
                    DATE_CREATED : FieldValue.serverTimestamp()
                    ], completion: { (error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        }else{
                            self.dismiss(animated: true, completion: nil)
                        }
                })
                
            })
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
