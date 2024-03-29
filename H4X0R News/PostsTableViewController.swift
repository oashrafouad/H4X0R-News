//
//  NewsTableViewController.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 08/09/2023.
//

import UIKit
import SafariServices
import LoadingIndicatorView

class PostsTableViewController: UITableViewController {
    
    var loadingIndicator = LoadingIndicatorView()
    var posts: [PostData] = []
    var cachedPosts: [PostData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "H4X0R News"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchPostIDs), for: .valueChanged)

        self.loadingIndicator.showHUD()
  
        fetchPostIDs()
    }
    
    @objc func fetchPostIDs()
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
        // Empty array first instead of appending to it
        cachedPosts = []
        
        // store first 100 post IDs only
        let shortenedPostIDsArray = Array(postIDsArray[0..<100])
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
                            self.cachedPosts.append(post)
                            
                            // Reload table view only when the for loop finishes and posts are loaded
                            if self.cachedPosts.count == shortenedPostIDsArray.count
                            {
                                DispatchQueue.main.sync {
                                    self.loadingIndicator.hideHUD()
                                    self.refreshControl?.endRefreshing()
                                    self.posts = self.cachedPosts
                                }
                                
                                DispatchQueue.main.async {
                                    UIView.transition(with: self.tableView, duration: 0.4, options: .transitionCrossDissolve)
                                    {
                                        self.tableView.reloadData()
                                    }
                                }
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
        cell.commentsButtonTapped = { [weak self] in
            self?.performSegue(withIdentifier: "commentsSegue", sender: self?.posts[indexPath.row].kids)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = posts[indexPath.row].url
        {
            let safariView = SFSafariViewController(url: url)
            self.present(safariView, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Can't open URL", message: "This post doesn't contain a URL link", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentsSegue", let kids = sender as? [Int] {
            let destinationVC = segue.destination as! CommentsTableViewController
            destinationVC.postKids = kids
        }
    }
}
