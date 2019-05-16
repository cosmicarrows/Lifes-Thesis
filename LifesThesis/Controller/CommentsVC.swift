//
//  CommentsVC.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/11/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Variables
    var thought: Thought!
    var comments = [Comment]()
    var thoughtRef: DocumentReference!
    let firestore = Firestore.firestore()
    var username: String!
    var commentListener: ListenerRegistration!
    
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var addCommentTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        thoughtRef = firestore.collection(THOUGHTS_REF).document(thought.documentID)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        self.view.bindToKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentListener = firestore.collection(THOUGHTS_REF).document(self.thought.documentID)
            .collection(COMMENTS_REF).addSnapshotListener({ (snapshot, error) in
                guard let snapshot = snapshot else {
                    debugPrint("Error fetching comments: \(error!)")
                    return
                }
                self.comments.removeAll()
                self.comments = Comment.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            })
    }
    

    @IBAction func addCommentTapped(_ sender: UIButton) {
        guard let commentTxt = addCommentTxt.text else { return }
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            
            let thoughtDocument: DocumentSnapshot
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore()
                .collection(THOUGHTS_REF).document(self.thought.documentID))
            } catch let error as NSError {
                debugPrint("Fetch error: \(error.localizedDescription)")
                return nil
            }
            //we also need to know how many comments it currently has
            guard let oldNumComments = thoughtDocument.data()?[NUM_COMMENTS] as? Int else { return nil}
            transaction.updateData([NUM_COMMENTS: oldNumComments + 1], forDocument: self.thoughtRef)
            
            let newCommentRef = self.firestore.collection(THOUGHTS_REF).document(self.thought.documentID).collection(COMMENTS_REF).document()
            
            transaction.setData([
                COMMENT_TXT : commentTxt,
                TIMESTAMP : FieldValue.serverTimestamp(),
                USERNAME : self.username], forDocument: newCommentRef)
            
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.addCommentTxt.text = ""
                self.addCommentTxt.resignFirstResponder()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell {
            cell.configureCell(comment: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
