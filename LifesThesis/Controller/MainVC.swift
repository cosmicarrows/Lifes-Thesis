//
//  ViewController.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/8/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


enum ThoughtCategory: String {
    case family = "family"
    case career = "career"
    case education = "education"
    case popular = "popular"
}

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Variables
    private var thoughts = [Thought]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.family.rawValue
    private var handle: AuthStateDidChangeListenerHandle?
    //Outlets
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            }else {
                self.setListener()
            }
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListener != nil {
            thoughtsListener.remove()
        }
    }
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.family.rawValue
        case 1:
            selectedCategory = ThoughtCategory.career.rawValue
        case 2:
            selectedCategory = ThoughtCategory.education.rawValue
        case 3:
            selectedCategory = ThoughtCategory.popular.rawValue
        default:
            selectedCategory = ThoughtCategory.family.rawValue
            //break
        }
        thoughtsListener.remove()
        setListener()
    }
    
    func setListener(){
        if selectedCategory == ThoughtCategory.popular.rawValue{
            //Observer that is a listener for our database
            thoughtsListener = thoughtsCollectionRef
                //.whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let err = error {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        self.thoughts.removeAll()
                        for document in (snapshot?.documents)!{
                            let data = document.data()
                            let username = data[USERNAME] as? String ?? "Anonymous"
                            let timestamp = data[TIMESTAMP] as? Date ?? Date()
                            let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
                            let numLikes = data[NUM_LIKES] as? Int ?? 0
                            let numComments = data[NUM_COMMENTS] as? Int ?? 0
                            let documentId = document.documentID
                            
                            let newThought = Thought.init(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentID: documentId)
                            
                            self.thoughts.append(newThought)
                        }
                        self.tableView.reloadData()
                    }
            }
            
        }else {
            //Observer that is a listener for our database
            thoughtsListener = thoughtsCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let err = error {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        self.thoughts.removeAll()
                        for document in (snapshot?.documents)!{
                            let data = document.data()
                            let username = data[USERNAME] as? String ?? "Anonymous"
                            let timestamp = data[TIMESTAMP] as? Date ?? Date()
                            let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
                            let numLikes = data[NUM_LIKES] as? Int ?? 0
                            let numComments = data[NUM_COMMENTS] as? Int ?? 0
                            let documentId = document.documentID
                            
                            let newThought = Thought.init(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentID: documentId)
                            
                            self.thoughts.append(newThought)
                        }
                        self.tableView.reloadData()
                    }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
        }
    }
}

