import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    var commentsButtonTapped: (() -> Void)?

    @IBAction func commentsButtonPressed(_ sender: UIButton) {
        commentsButtonTapped?()
    }
}
