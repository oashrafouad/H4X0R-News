//
//  NewsTableViewController.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 08/09/2023.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var array: [String] = []
    var posts: [PostData] = []
    let queue = OperationQueue()
    var session : URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: queue)
//        print(session)
        
        self.title = "H4X0R News"

        fetchPostsList()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func retrieveButtonPressed(_ sender: UIBarButtonItem) {
        print(posts)
    }
    

    func fetchPostsList()
    {
        if let url = URL(string: K.websiteURL)
        {

            let task = session!.dataTask(with: url) { data, response, error in
                if error != nil
                {
                    print(error!)
                }
                
                if let safeData = data
                {
                    do
                    {
                        let results = try JSONDecoder().decode([Int].self, from: safeData)
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
        
        for postID in shortenedPostList
        {
            if let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(postID).json")
            {
                let task = session!.dataTask(with: url) { data, response, error in
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
        sleep(4)
        DispatchQueue.main.async {
            self.tableView.reloadData()

        }
    }
    
    func parsePostDataArray(from postDataArray: [PostData])
    {
        
    }
    
    
    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
//         #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        cell.postLabel?.text = posts[indexPath.row].title
        cell.upvotesLabel.text = "\(posts[indexPath.row].score)"
        
//        var content = cell.defaultContentConfiguration()
//
//        content.text = array[indexPath.row]
//        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension NewsTableViewController: URLSessionTaskDelegate
{
    
}
