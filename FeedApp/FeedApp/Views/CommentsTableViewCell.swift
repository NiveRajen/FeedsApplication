//
//  CommentsTableViewCell.swift
//  FeedApp
//
//  Created by Nivedha Rajendran on 15/05/21.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblComments: UILabel!
  
  //Initializing comment object and populating data
  var comment: Comments? {
    
    didSet {
      
      if let comment = comment {
        
        lblName.text = comment.name
        lblComments.text = comment.body
      }
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
