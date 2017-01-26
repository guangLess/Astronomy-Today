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
            else{ return nil }
        
        self.date = date
        self.explanation = explanation
        self.media_type = media_type
        self.title = title
        self.url = url
    }
}

struct Resource<Apod> {
    let url: URL
    let parse: (Data) -> Apod?
}
/*
extension Resource{
    init(url: NSURL, parseJSON:  (AnyObject) -> Day?){
            self.url = url

    }
}
*/
final class Webservice {
    func load<Apod>(resource: Resource<Apod>, completion: @escaping (Apod?) -> () ){
//        URLSession.shared.dataTask(with: resource.url as URL) { data, _, _ in
//            if let data = data {
//                completion(resource.parse(data as NSData))
//            } else {
//                completion(nil)
//            }
//            }.resume()
        
        URLSession.shared.dataTask(with: resource.url) { (data, _, _) in
            if let data = data {
                completion(resource.parse(data))
            }
        }
    }

}

//let apodResource = Resource<NSData>(url: url, parse: { data in
//    return data
//})


