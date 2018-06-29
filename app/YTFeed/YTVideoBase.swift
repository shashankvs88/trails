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
    let CHANNEL_ID = "UCPSb5hoJuGd_M421vocSM2A"   // YouTube playlist url id
    

    let YOUTUBE_PLAYLIST_URL = "https://www.googleapis.com/youtube/v3/search"
    
    var videoArray = [Video]()
    var delegate : VideoModelDelegate?
    var nextPageToken: String?

    
    func getFeedVideos() {
        
        //fetch the video dynamically through the YouTube Data API
        Alamofire.request((YOUTUBE_PLAYLIST_URL), parameters: ["part":"snippet","order":"viewCount", "channelId":CHANNEL_ID,"maxResults":"50","pageToken":nextPageToken ?? "","key":API_KEY], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let JSON = response.result.value {
                if let token = (JSON as! NSDictionary)["nextPageToken"] as? String {
                  self.nextPageToken = token
                }
                guard let jsonArr = (JSON as! NSDictionary)["items"] as? NSArray else { return }
                for video in jsonArr {
                let videoObj = Video()
                    if  let vId = (video as! NSDictionary).value(forKeyPath: "id.videoId") as? String {
                        videoObj.videoId = vId
                        videoObj.channelTitle = (video as! NSDictionary).value(forKeyPath: "snippet.channelTitle") as! String
                        videoObj.videoTitle = (video as! NSDictionary).value(forKeyPath: "snippet.title") as! String
                        videoObj.videoDescription = (video as! NSDictionary).value(forKeyPath: "snippet.description") as! String
                        videoObj.videoUrl  = URL(string:"youtube.com/watch?v=" + videoObj.videoId)
                        videoObj.videoThumbnailUrl = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.high.url") as! String
                        self.videoArray.append(videoObj)
                    }
                }
                
            
                
            //notify the delegate that the data is ready
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
                
            }
        }
}
    
    
}
