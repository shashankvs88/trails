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
        print("Detail View: \(photoUrl?.absoluteString)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "FullScreenPhotoSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fullScreenPhotoVC = segue.destination as! FullScreenPhotoViewController
        
        fullScreenPhotoVC.photoUrl = self.photoUrl
    }
    
}
