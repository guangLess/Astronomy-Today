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
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=XQCVvM7SkdY4qrvNXSH00TkO6wRpsgPQyYDeA09T"//DEMO_KEY"
        let request = NSURLRequest(URL:NSURL(string:urlString)!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            print(response)
            
            //var errorOptional : NSError?
            //let jsonOptional = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: errorOptional)

            /*
             var jsonErrorOptional: NSError?
             let jsonOptional: JSON! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
             
             // if there was an error parsing the JSON send it back
             if let err = jsonErrorOptional {
             callback(.Error(err))
             return
             }
             */
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
                    let defalutData = Today.init(date: "", explanation: "There is a connection issue", media_type: "", title: "", url: "x.png", copyright: "")
                    completion(defalutData)
                }
            }
        }
        task.resume()
    }
}
