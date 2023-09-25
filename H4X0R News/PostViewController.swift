//
//  PostViewController.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 24/09/2023.
//

import UIKit
import WebKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url : URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if url != nil
        {
            webView.load(URLRequest(url: url!))
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Error viewing webpage", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
