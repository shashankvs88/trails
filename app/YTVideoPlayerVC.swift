//
//  YTVideoPlayerVC.swift
//  app
//
//  Created by Motive on 26/06/18.
//  Copyright © 2018 shashank vs. All rights reserved.
//

import Foundation
import UIKit
import YouTubePlayer


class YTVideoPlayerVC : UIViewController  {
    
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    var videoId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.loadVideoID(videoId)
    }
}
