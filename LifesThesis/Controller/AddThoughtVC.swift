//
//  AddThoughtVC.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/9/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddThoughtVC: UIViewController, UITextViewDelegate {

    //Outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var thoughtTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    //Variables
    private var selectedCategory = ThoughtCategory.family.rawValue
    override func viewDidLoad() {
        super.viewDidLoad()
        postBtn.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        thoughtTxt.text = "My random thought..."
        thoughtTxt.textColor = UIColor.lightGray
        thoughtTxt.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.family.rawValue
        case 1:
            selectedCategory = ThoughtCategory.career.rawValue
        default:
            selectedCategory = ThoughtCategory.education.rawValue
        }
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let username = usernameTxt.text else {
            return
        }
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT : thoughtTxt.text,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : username
        
        ]) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
