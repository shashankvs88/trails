//
//  PhotoDetailsViewController.swift
//  InstgrmFeed
//
//  Created by Tran Khanh Trung on 3/26/17.
//  Copyright © 2017 KhanhTrung. All rights reserved.
//

import UIKit
//import AFNetworking

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    var photoUrl = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.setImageWith(photoUrl!)
        UINavigationBar.appearance().barTintColor = UIColor.red
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        print("Detail View: \(photoUrl?.absoluteString)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        //performSegue(withIdentifier: "FullScreenPhotoSegue", sender: nil)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
       dismiss(animated: true, completion: nil)
    }
    
}
