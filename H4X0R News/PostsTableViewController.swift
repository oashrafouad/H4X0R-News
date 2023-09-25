//
//  NewsTableViewController.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 08/09/2023.
//

import UIKit
import SafariServices

class PostsTableViewController: UITableViewController {
    
    var posts: [PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "H4X0R News"

        fetchPostIDs()
    }

    func fetchPostIDs()
    {
        let session = URLSession(configuration: .default)
        if let url = URL(string: K.websiteURL)
        {
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil
                {
                    print(error!)
                }
                
                if let safeData = data
                {
                    do
                    {
                        let results = try JSONDecoder().decode([Int].self, from: safeData)
                        self.parsePostData(from: results)
                    }
                    catch
                    {
                        print(error)
                    }

                }
            }
            task.resume()
        }
    }
    
    func parsePostData(from postIDsArray: [Int])
    {
        // store first 30 post IDs only
        let shortenedPostIDsArray = Array(postIDsArray[0..<30])
        let session = URLSession(configuration: .default)
        for postID in shortenedPostIDsArray
        {
            if let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(postID).json")
            {
                let task = session.dataTask(with: url) { data, response, error in
                    if error != nil
                    {
                        print(error!)
                    }
                    
                    if let safeData = data
                    {
                        do
                        {
                            let post = try JSONDecoder().decode(PostData.self, from: safeData)
                            self.posts.append(post)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! PostsTableViewCell
        
        cell.postLabel?.text = posts[indexPath.row].title
        cell.upvotesLabel.text = "\(posts[indexPath.row].score)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: K.postSegue, sender: posts[indexPath.row].url)
        let safariView = SFSafariViewController(url: posts[indexPath.row].url)
        
        self.present(safariView, animated: true)
        
    }
}
