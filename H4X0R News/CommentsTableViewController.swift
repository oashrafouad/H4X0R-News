//
//  CommentsTableViewController.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 07/02/2024.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var postKids: [Int] = []
    var commentsText: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadComments()
    }
    
    func loadComments() {
        if !postKids.isEmpty {
            let session = URLSession(configuration: .default)
            for commentID in postKids {
                if let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(commentID).json") {
                    let task = session.dataTask(with: url) { data, response, error in
                        
                        if error != nil {
                            print("Error performing task: \(error!.localizedDescription)")
                        }
                        
                        if let safeData = data {
                            do {
                                let comment = try JSONDecoder().decode(CommentData.self, from: safeData)
                                do {
                                    if let data = comment.text?.data(using: .utf8) {
                                        let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                                        self.commentsText.append(attributedString.string)
                                        
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    }
                                    
                                } catch {
                                    print("Error creating attributed string: \(error)")
                                }
                            } catch {
                                print("Error decoding: \(error.localizedDescription)")
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsText.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentsTableViewCell
        cell.commentLabel.text = commentsText[indexPath.row]
        return cell
    }
}
