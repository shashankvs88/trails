//
//  FanVideoBase.swift
//  FanApp+
//
//  Created by Navneet Prakash on 3/10/16.
//  Copyright © 2016 Navneet Prakash. All rights reserved.
//

import Foundation
import Alamofire

protocol VideoModelDelegate {
    
    func dataReady()
}

class YTVideoBase {
    
    let API_KEY = "AIzaSyAoWHEmq7YsNWephdjh4mTIgIDaq07kwmY" // YouTube API key from console
    let UPLOADS_PLAYLIST_ID = "PLivjPDlt6ApTqKN6DbR-GOM5omen0Xm2a"   // YouTube playlist url id // national geographic channel ocean playlist
    

    let YOUTUBE_PLAYLIST_URL = "https://www.googleapis.com/youtube/v3/search"
    
    var videoArray = [Video]()
    var delegate : VideoModelDelegate?

    
    func getFeedVideos() {
        
        //fetch the video dynamically through the YouTube Data API
        Alamofire.request((YOUTUBE_PLAYLIST_URL), parameters: ["part":"snippet", "channelId":"UCPSb5hoJuGd_M421vocSM2A","maxResults":"50", "key":API_KEY], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            
            if let JSON = response.result.value {
                var arrayOfVideos = [Video]()
                
                for video in (JSON as! NSDictionary)["items"] as! NSArray {
                let videoObj = Video()
                videoObj.channelTitle = (video as! NSDictionary).value(forKeyPath: "snippet.channelTitle") as! String
                videoObj.videoId = (video as! NSDictionary).value(forKeyPath: "id.videoId") as! String
                videoObj.videoTitle = (video as! NSDictionary).value(forKeyPath: "snippet.title") as! String
                videoObj.videoDescription = (video as! NSDictionary).value(forKeyPath: "snippet.description") as! String
                videoObj.videoUrl  = URL(string:"youtube.com/watch?v=" + videoObj.videoId)
                videoObj.videoThumbnailUrl = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.high.url") as! String
                
                arrayOfVideos.append(videoObj)
                
                }
                
            self.videoArray = arrayOfVideos
            
                
            //notify the delegate that the data is ready
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
                
            }
        }
}
    
    
}
