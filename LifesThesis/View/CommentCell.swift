//
//  CommentCell.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/11/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    
    
    func configureCell(comment: Comment){
        usernameTxt.text = comment.username
        commentTxt.text = comment.commentTxt
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampTxt.text = timestamp
    }

    

}
