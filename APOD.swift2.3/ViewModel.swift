//
//  ViewModel.swift
//  APOD.swift2.3
//
//  Created by Guang on 1/25/17.
//  Copyright © 2017 Guang. All rights reserved.
//

import Foundation

//struct Media {
//    let media_type : type
//    //let content:
//}
//
//enum type:String {
//    case image = "image"
//    case video = "video"
//}
//
//struct ApodViewModel {
//    /*
//     todayTitle: UILabel!
//     mediaView: UIView!
//     descriptionText: UITextView!
//     todayImageView: UIImageView!
//     */
//    let title: String
//    let media_Type: String
//    let description: String
//    
//    init?(day: Day) {
//        self.title = day.title
//        self.media_Type = day.media_type
//        self.description = day.explanation
//    }
//    
//}
//
//    
let aurl = NSURL(string: "https://api.nasa.gov/planetary/apod?api_key=XQCVvM7SkdY4qrvNXSH00TkO6wRpsgPQyYDeA09T")!
let dayResource = Resource(url: aurl, parseJSON: { anyObject in
    (anyObject as? NSDictionary).flatMap(Day.init)
})

protocol LoadingApod {
    //var lineViewTwo : LineView {get}
    //func configure(value: Day)
}

extension LoadingApod where Self: ApodViewController {
    func load(resource: Resource, compliction:(dayContent: Day) -> Void)  {
        Webservice().load(resource) { result in
            print("-------------------\(result)")
                    guard let todayData = result else {return}
            compliction(dayContent: todayData)
            
        }
    }
}
