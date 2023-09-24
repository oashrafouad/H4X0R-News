//
//  NewsTableViewController.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 08/09/2023.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var posts: [PostData] = []
    let queue = OperationQueue()
    var session : URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "H4X0R News"

        fetchPostsList()
    }
    
    @IBAction func retrieveButtonPressed(_ sender: UIBarButtonItem) {
        print(posts)
    }
    

    func fetchPostsList()
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
                        let decoder = JSONDecoder()
                        let results = try decoder.decode([Int].self, from: safeData)
                        self.fetchPostData(from: results)
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
    
    func fetchPostData(from postList: [Int])
    {
        // store first 100 values only from array
        let shortenedPostList = Array(postList[0..<15])
        print(shortenedPostList.count)
        let session = URLSession(configuration: .default)
        var counter = 0
        for postID in shortenedPostList
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
                            let post = try JSONDecoder().decode(PostData.self, from: safeData)
                            self.posts.append(post)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()

                            }
                            counter += 1
                            print(counter)
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
//        sleep(1)
    }
    
    func parsePostDataArray(from postDataArray: [PostData])
    {
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        cell.postLabel?.text = posts[indexPath.row].title
        cell.upvotesLabel.text = "\(posts[indexPath.row].score)"
        
//        var content = cell.defaultContentConfiguration()
//
//        content.text = posts[indexPath.row].title
//        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension NewsTableViewController: URLSessionTaskDelegate
{
    
}
