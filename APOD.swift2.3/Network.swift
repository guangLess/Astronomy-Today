//
//  Network.swift
//  APOD.swift2.3
//
//  Created by Guang on 10/4/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation

struct Today {
    let date: String
    let explanation: String
    let media_type: String
    let title: String
    let url: String
    let copyright: String
    static func create(date: String, explanation: String, media_type: String, title: String, url: String, copyright: String) ->Today {
        return Today(date: date, explanation: explanation, media_type: media_type, title: title, url: url, copyright: copyright)
    }
}
protocol NetworkController {
    func getTodayInfo(completion: Today -> Void)
}
class ApodNetwork: NetworkController {
    func getTodayInfo(completion: Today -> Void) {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        let request = NSURLRequest(URL:NSURL(string:urlString)!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if let data = data{
                let response = NSString(data: data, encoding: NSUTF8StringEncoding)
                print(response)
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)
                    print(json)
                    let date = json["date"].map({$0 as! String}) ?? "xo"
                    let copyright = json["copyright"].map({$0 as! String}) ?? "xo"
                    let explanation = json["explanation"].map({$0 as! String}) ?? "xo"
                    let media_type = json["media_type"].map({$0 as! String}) ?? "xo"
                    let title = json["title"].map({$0 as! String}) ?? "xo"
                    let url = json["url"].map({$0 as! String}) ?? "xo"
                    let today = Today.create(date, explanation: explanation, media_type: media_type, title: title, url: url,copyright:copyright)
                    completion(today)
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
}