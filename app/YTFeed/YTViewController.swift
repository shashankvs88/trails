//
//  ViewController.swift
//
//

import UIKit
import AVFoundation
import WebKit

class YTViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VideoModelDelegate, FeedTableViewProtocol, WKNavigationDelegate {
    
    
    var isMoreDataLoading = false
    var webView: WKWebView!
    var  activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    var videoList: [Video] = [Video]()
    var model = YTVideoBase ()
    var refreshControl: UIRefreshControl?
    var loadingMoreView:InfiniteScrollActivityView?

    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.model.delegate = self
        
        model.getFeedVideos()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        self.closeButton.isHidden = true
    }

    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
    
    @objc func refreshData(_ refreshControl: UIRefreshControl) {
        // Code to refresh table view
        if (isMoreDataLoading == false) {
            model.nextPageToken = ""
        }
        model.getFeedVideos()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
        userLabel.text = videoList.first?.channelTitle
        
    }
    
    func dataReady() {
        
        //access the video objects that hav been downloaded

        let indexPath = isMoreDataLoading ?  IndexPath(row: self.videoList.count, section: 0) : IndexPath(row: 0, section: 0)
        self.videoList = self.model.videoArray
        self.isMoreDataLoading = false
        //tell the tableView to reload
        tableView.reloadData()
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        self.loadingMoreView!.stopAnimating()
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
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
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
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        if webView != nil {
        if self.view.subviews.contains(webView) {
            webView.removeFromSuperview()
            }
        }
        webView = WKWebView(frame: CGRect(x: 0, y: tableView.frame.origin.y, width: tableView.frame.width, height: 300), configuration: webConfiguration)
        webView.backgroundColor =  UIColor.darkGray
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.closeButton.isHidden = false
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.webView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        if let videoURL:URL = URL(string: "https://www.youtube.com/embed/\(videoList[indexPath.row].videoId)?playsinline=1") {
            let request:URLRequest = URLRequest(url: videoURL)
            webView.load(request)
        }
        
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        print("loaded")
        activityIndicator.stopAnimating()
    }
    
    @IBAction func closeWebView() {
        webView.removeFromSuperview()
        self.closeButton.isHidden = true

    }
    
}


extension UIImageView{
    
    func setImageWith(_ url: URL){
        
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
    }
}
