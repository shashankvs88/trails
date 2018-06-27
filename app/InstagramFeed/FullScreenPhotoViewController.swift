//
//  FullScreenPhotoViewController.swift
//  InstgrmFeed
//
//  Created by Tran Khanh Trung on 4/1/17.
//  Copyright © 2017 KhanhTrung. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoUrl = URL(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        photoImageView.setImageWith(photoUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dissmisFullScreenView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension FullScreenPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
}
