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


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let session = URLSession(configuration: .default)
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
        let session = URLSession(configuration: .default)
        for postID in postList
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
//         #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        cell.postLabel?.text = array[indexPath.row]
        cell.upvotesLabel.text = "1"
        
//        var content = cell.defaultContentConfiguration()
//
//        content.text = array[indexPath.row]
//        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
