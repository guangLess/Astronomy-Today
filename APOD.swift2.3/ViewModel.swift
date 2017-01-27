//
//  ViewModel.swift
//  APOD.swift2.3
//
//  Created by Guang on 1/25/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import Foundation

struct Media {
    let media_type : type
    //let content:
}

enum type:String {
    case image = "image"
    case video = "video"
}

struct ApodViewModel {
    /*
     todayTitle: UILabel!
     mediaView: UIView!
     descriptionText: UITextView!
     todayImageView: UIImageView!
     */
    let title: String
    let media_Type: String
    let description: String
    
    init?(day: Day) {
        self.title = day.title
        self.media_Type = day.media_type
        self.description = day.explanation
    }
    
}

    


