//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

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

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource{
    init(url: URL, parseJSON:  @escaping (Any) -> A?){
            self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

final class Webservice {
    func load(resource: Resource<Day>, completion: @escaping (Day?) -> () ){
        URLSession.shared.dataTask(with: resource.url) { (data, _, _) in
            guard let data = data else
                {completion(nil)
                return}
            completion(resource.parse(data))
        }.resume()
    }
}
//---------call networks----------------
struct ApodViewModel {
    var dayContentCallback: ((_ dayContent: Day) -> Void)?
    func getDayContent(_ complietion: @escaping (_ dayContent: Day) -> Void){
        //TOFIX: make it into APIKEY file
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=XQCVvM7SkdY4qrvNXSH00TkO6wRpsgPQyYDeA09T")!
        let apodResource = Resource<Day>(url: url, parseJSON: { json in
            guard let dictionary = json as? apodDict else {return nil}
            return Day.init(dictionary: dictionary)
        })
        Webservice().load(resource: apodResource) { day in
            print(day)
            guard let apodDay = day else {fatalError("Can not get webservice content")}
                complietion(apodDay)
        }
    }
}

