//
//  PhotosViewController.swift
//  InstgrmFeed
//
//  Copyright © 2017 KhanhTrung. All rights reserved.
//

import UIKit

//Khanh Trung
let USER_ID = "200697590"
// get from http://instagram.pixelunion.net/
let ACCESS_TOKEN = "200697590.1677ed0.2657b3d4867b415abe5908665b11d5a2"

protocol FeedTableViewProtocol {
    
    func refreshData(_ refreshControl: UIRefreshControl)
    
    var refreshControl: UIRefreshControl? { get set }
    var isMoreDataLoading: Bool  { get set }
    var loadingMoreView:InfiniteScrollActivityView? { get set }
    var tableView: UITableView! { get set }
}

class PhotosViewController: UIViewController , FeedTableViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var burgerButton: UIButton!
    
    
    var photoDataArray: [NSDictionary]?
    var refreshControl: UIRefreshControl?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = 320
        
        tableView.dataSource = self;
        tableView.delegate = self
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)
        refreshData(refreshControl!)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        userImageView.frame = CGRect(x:(burgerButton.frame.origin.x + burgerButton.frame.width + 10) , y:  burgerButton.frame.origin.y/2, width: 40, height: 40)
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 20
        userImageView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        userImageView.layer.borderWidth = 1
    }
    
    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination  as! UINavigationController
        let detailView = navVC.topViewController as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: sender as!UITableViewCell)!
        
        let photoData = photoDataArray?[indexPath.row]
        
        // Photo
        let photoImages = photoData?["images"] as! NSDictionary
        let photoStandard = photoImages["standard_resolution"] as! NSDictionary
        let urlString = photoStandard["url"]
        let photoURL = URL(string: urlString as! String)
        
        detailView.photoUrl = photoURL
    }
    
    @objc func refreshData(_ refreshControl: UIRefreshControl) {
        

        let url = URL(string: "https://api.instagram.com/v1/users/\(USER_ID)/media/recent/?access_token=\(ACCESS_TOKEN)")
        
        if let url = url {
            let request = URLRequest(
                url: url,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(
                with: request,
                completionHandler: { (dataOrNil, response, error) in
                    // Update flag
                    self.isMoreDataLoading = false
                    
                    // Stop the loading indicator
                    self.loadingMoreView!.stopAnimating()
                    
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            if let photoData = responseDictionary["data"] as? [NSDictionary] {
                                
                                self.photoDataArray = photoData
                                self.tableView.reloadData()
                            }
                        }
                    }
                    refreshControl.endRefreshing()
            })
            task.resume()
        }
    }
}

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Uncommnet this if cell has header
        // return 1
        
        if photoDataArray != nil { return photoDataArray!.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotosTableViewCell
        
        let photoData = photoDataArray![indexPath.row]
        
        // User photo
        let userData = photoData["user"] as!NSDictionary
        let userProfilePicUrl = userData["profile_picture"]
        userImageView.setImageWith(URL(string: userProfilePicUrl as! String)!)

        // User name
//        let userName = userData["full_name"]
//        photoCell.userName.text = userName as! String?
//        
        // Photo
        let photoImages = photoData["images"] as! NSDictionary
        let photoStandard = photoImages["standard_resolution"] as! NSDictionary
        let urlString = photoStandard["url"]
        let photoURL = URL(string: urlString as! String)
        photoCell.photoImageView.setImageWith(photoURL!)
        
        //print("photoUrl - \(indexPath.row): \(urlString)")
        
        return photoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Remove the gray selection effect
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Uncommnet this if cell has header
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        if photoDataArray != nil { return photoDataArray!.count }
        else { return 0 }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1

        let userNameView = UILabel(frame: CGRect(x: 48, y: 10, width: 200, height: 30))
        
        
        // Use the section number to get the right URL
        let photoData = photoDataArray![section]
        
        // User photo
        let userData = photoData["user"] as!NSDictionary
        let userProfilePicUrl = userData["profile_picture"]
        profileView.setImageWith(URL(string: userProfilePicUrl as! String)!)
        
        // User name
        let userName = userData["full_name"] as! String
        userNameView.text = userName
        
        headerView.addSubview(profileView)
        headerView.addSubview(userNameView)
        return headerView
    }
     */
}

extension YTViewController  {
    
    // Display loading indicator when scroll to near end of table@nonobjc
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                refreshData(refreshControl!)
            }
        }
    }
}

class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}















