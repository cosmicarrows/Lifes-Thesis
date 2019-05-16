//
//  ThoughtCell.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/9/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var likesNumLbl: UILabel!
    
    @IBOutlet weak var commentsNumLabel: UILabel!
    private var thought: Thought!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(likeTapped))
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped(){
        Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentID).setData([NUM_LIKES : thought.numLikes + 1], merge: true)
        
    }
    
    func configureCell(thought: Thought){
        self.thought = thought
        usernameLbl.text = thought.username
        //timestampLbl.text = thought.timestamp
        thoughtTxtLbl.text = thought.thoughtTxt
        likesNumLbl.text = String(thought.numLikes)
        commentsNumLabel.text = String(thought.numComments)
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLbl.text = timestamp
    }

    

}
