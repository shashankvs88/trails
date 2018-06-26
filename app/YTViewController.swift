//
//  ViewController.swift
//  EditSoftDemo
//
//  Created by Saurabh Yadav on 31/01/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

class YTViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VideoModelDelegate {
    
    var webView: WKWebView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    var videoList: [Video] = [Video]()
    let model = YTVideoBase ()
    var refreshControl: UIRefreshControl!
    
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.model.delegate = self
        
        model.getFeedVideos()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for:UIControlEvents.valueChanged)
        feedTableView.addSubview(refreshControl)
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
    }

    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        feedTableView.reloadData()
        self.refreshControl?.endRefreshing()
        userLabel.text = videoList.first?.channelTitle
    }
    
    func dataReady() {
        
        //access the video objects that hav been downloaded
        self.videoList = self.model.videoArray
        
        //tell the tableView to reload
        feedTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.feedTableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            let videoTitle = videoList[indexPath.row].videoTitle
            let videoThumbnail = videoList[indexPath.row].videoThumbnailUrl
            cell.desclabel.text = videoTitle
            userLabel.text = videoList.first?.channelTitle
        if videoThumbnail != nil {
            
            //create a NSUrlRequest object
            guard let videoUrl = URL (string:videoThumbnail) else { return UITableViewCell () }
            let request = NSURLRequest(url: videoUrl)
            
            //create a NSURLSession
            let session = URLSession.shared
            
            //create a datatask and pass it in the request
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                DispatchQueue.main.async {
                    //get the reference to the imageView of the cell
                    cell.imageVIew.image = UIImage(data : data!)
                    
                }
            })
            
            dataTask.resume()
        }
        
            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // self.performSegue(withIdentifier: "VideoVC", sender: videoList[indexPath.row].videoId)
//        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.allowsInlineMediaPlayback = true
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        view = webView
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 375, height: 300), configuration: webConfiguration)

        self.view.addSubview(webView)
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/\(videoList[indexPath.row].videoId)?playsinline=1") {
            let request:URLRequest = URLRequest(url: videoURL)
            webView.load(request)
        }
//
//        let url = NSURL(string: "https://www.youtube.com/embed/\(videoList[indexPath.row].videoId)?autoplay=1")
//        let requestObj = NSURLRequest(url: url! as URL)
//        webView.load(requestObj as URLRequest)
//        webView.scrollView.isScrollEnabled = false
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if let destination = segue.destination as? YTVideoPlayerVC {
//            
//            if let video = sender as? Video{
//                destination.videoId = video.videoId
//            }
//        }
//    }
}
