//
//  NewsTableViewController.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 08/09/2023.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    var posts: [PostData] = []
    var index = 0
    
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
//                            print(String(data: safeData, encoding: .utf8)!)
//                            print("\n")
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
        
//        var content = cell.defaultContentConfiguration()
//
//        content.text = posts[indexPath.row].title
//        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(posts[indexPath.row].url)
        index = indexPath.row
        self.performSegue(withIdentifier: K.postSegue, sender: posts[indexPath.row].url)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == K.postSegue)
        {
            let destinationVC = segue.destination as! PostViewController
            let url = sender as! URL
            destinationVC.url = url
        }
    }
    

}
