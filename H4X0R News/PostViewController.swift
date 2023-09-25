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
        
        webView.allowsBackForwardNavigationGestures = true
        
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
}
