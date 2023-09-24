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
        
//        let webConfiguartion = WKWebViewConfiguration()
        webView.load(URLRequest(url: url!))
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
