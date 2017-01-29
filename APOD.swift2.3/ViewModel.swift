//
//  ViewModel.swift
//  APOD.swift2.3
//
//  Created by Guang on 1/25/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import Foundation
import UIKit

typealias apodDict = [String: String]

struct Day{
    let date: String
    let explanation: String
    let media_type: String
    let title: String
    let url: String
}
//FIXME: Change it to Dictionary. No need to cast String
extension Day {
    init?(dictionary: apodDict) {
        guard let date = dictionary["date"],
            explanation = dictionary["explanation"],
            media_type = dictionary["media_type"],
            title = dictionary["title"],
            url = dictionary["url"]
            //copyright = dictionary["copyright"] as? String
            else{ return nil }
        
        self.date = date
        self.explanation = explanation
        self.media_type = media_type
        self.title = title
        self.url = url
        //self.copyright = copyright
    }
}


struct Media {
    let type: String
    let url: String
    let displayImage: (UIImageView, String)->() = { imageView, url in
        let image = NSURL(string:url)
            .flatMap{NSData(contentsOfURL: $0)}
            .flatMap{UIImage(data: $0)}
        imageView.image = image
    }
    let displayVideo: (UIView, String) -> () = { view, url  in
        let videoView = UIWebView()
        videoView.frame = view.bounds
        videoView.backgroundColor = UIColor.clearColor()
        view.addSubview(videoView)
        videoView.loadRequest(NSURLRequest(URL:NSURL(string: url)!))
    }
}
extension Media  {
    func configurTo(mediaView: UIView, todayImageView: UIImageView){
        switch self.type {
        case "image" :
            displayImage(todayImageView,self.url)
            print("x image")
        case "video" :
            print("x video")
            displayVideo(mediaView, self.url)
        default: "other"
        }
    }
}


