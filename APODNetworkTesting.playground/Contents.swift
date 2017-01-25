//: Playground - noun: a place where people can play

import UIKit

typealias apodDict = [String: String]
struct Day{
    let date: String
    let explanation: String
    let media_type: String
    let title: String
    let url: String
}
extension Day {
    init?(dictionary: apodDict) {
        guard let date = dictionary["date"],
            let explanation = dictionary["explanation"],
            let media_type = dictionary["media_type"],
            let title = dictionary["title"],
            let url = dictionary["url"]
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




