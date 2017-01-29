//
//  WebService.swift
//  APOD.swift2.3
//
//  Created by Guang on 10/25/16.
//  Copyright © 2016 Guang. All rights reserved.
//
import Foundation
import UIKit

struct Resource<A> {
    let url: NSURL
    let parse: NSData -> A?
}
extension Resource{
    init(url: NSURL, parseJSON: AnyObject -> A?){
        self.url = url
        self.parse = { data in
           let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

final class Webservice {
    func request(resource: Resource<Day>, completion: (Day?) -> ()){
        NSURLSession.sharedSession().dataTaskWithURL(resource.url){ data,_,_ in
            if let data = data{
                let parseData = resource.parse(data)
                completion(parseData)
            }else {
                completion(nil)
            }
        }.resume()
    }
}

let aurl = NSURL(string: "https://api.nasa.gov/planetary/apod?api_key=XQCVvM7SkdY4qrvNXSH00TkO6wRpsgPQyYDeA09T")!
let dayResource = Resource<Day>(url: aurl, parseJSON: { json in
    guard let dictionary = json as? apodDict else {return nil}
    return Day.init(dictionary: dictionary)
})

protocol LoadingApod {}
extension LoadingApod where Self: ApodViewController {
    func load(resource: Resource<Day>, compliction:(dayContent: Day) -> Void)  {
        Webservice().request(resource) { result in
            print("-------------------\(result)")
            guard let todayData = result else {return}
            compliction(dayContent: todayData)
            
        }
    }
}
