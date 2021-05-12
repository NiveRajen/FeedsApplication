//
//  FeedTableViewCell.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblPostBody: UILabel!
  
  //Initializing feed object and populating data
  var feed: Feed? {
    
    didSet {
      
      if let feed = feed {
        
        lblTitle.text = feed.title
        lblPostBody.text = feed.body      }
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
