//
//  YTVideoPlayerVC.swift
//  app
//
//  Created by Motive on 26/06/18.
//  Copyright © 2018 shashank vs. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class YTVideoPlayerVC : UIViewController  {
    
    
    @IBOutlet weak var webView : WKWebView!
    var videoId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = NSURL(string: "https://www.youtube.com/watch?v=\(videoId)")
        let requestObj = NSURLRequest(url: url! as URL)
        webView.load(requestObj as URLRequest)
        webView.scrollView.isScrollEnabled = false
    }
}
