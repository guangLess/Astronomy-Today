//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct Media {
    let type : String
}
extension Media  {
    func configur() -> String {
        switch self.type {
        case "image" :
            let imageS = "x image"
            print(imageS)
            return imageS
        case "video" :
            let videoS = "x video"
            print(videoS)
            return videoS
        default: "other"
        return "media unknow"
        }
    }
}
//Media().configurMedia(type: media_type)
//type"".configureMedia
let M = Media(type: "image").configur()