//
//  WebService.swift
//  APOD.swift2.3
//
//  Created by Guang on 10/25/16.
//  Copyright © 2016 Guang. All rights reserved.
//
import Foundation
import UIKit

struct Day{
    let date: String
    let explanation: String
    let media_type: String
    let title: String
    let url: String
}
extension Day {
    init?(dictionary: NSDictionary) {
        guard let date = dictionary["date"] as? String,
               explanation = dictionary["explanation"] as? String,
               media_type = dictionary["media_type"] as? String,
               title = dictionary["title"] as? String,
               url = dictionary["url"] as? String
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

struct Resource {
    let url: NSURL
    let parse: NSData -> Day?
}
extension Resource{
    init(url: NSURL, parseJSON: AnyObject -> Day?){
        self.url = url
        self.parse = { data in
           let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            let testJson = json.flatMap(parseJSON)
            print(testJson)
            return json.flatMap(parseJSON)
        }
    }
}
//let apodUrl = NSURL(string: "https://api.nasa.gov/planetary/apod?api_key=XQCVvM7SkdY4qrvNXSH00TkO6wRpsgPQyYDeA09T")!
//extension Day {
//    static let all = Resource(url: apodUrl, parseJSON: { json in
//        guard let dictionary = json as? NSDictionary else {return nil}
//        let day = Day.init(dictionary:dictionary)
//        return day
//    })
//}

final class Webservice {
    func load(resource: Resource, completion: (Day?) -> ()){
        NSURLSession.sharedSession().dataTaskWithURL(resource.url){ data,_,_ in
            if let data = data{
                let parseData = resource.parse(data)
                print(parseData)
                completion(parseData)
            }else {
                completion(nil)
            }
        }.resume()
    }
}
















