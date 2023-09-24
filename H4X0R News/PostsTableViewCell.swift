//
//  NewsTableViewCell.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 09/09/2023.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
