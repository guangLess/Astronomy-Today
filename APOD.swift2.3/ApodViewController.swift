//
//  ApodViewController.swift
//  APOD.swift2.3
//  Created by Guang on 10/3/16.
//  Copyright © 2016 Guang. All rights reserved.
import UIKit
import Photos

let aurl = NSURL(string: "https://api.nasa.gov/planetary/apod?api_key=XQCVvM7SkdY4qrvNXSH00TkO6wRpsgPQyYDeA09T")!
//FIXME: no need to cast type it is all Strings
let dayResource = Resource(url: aurl, parseJSON: { anyObject in
    (anyObject as? NSDictionary).flatMap(Day.init)
})
let sharedWebservice = Webservice()

protocol Loading {
    var lineViewTwo : LineView {get}
    func configure(value: Day)
}

extension Loading where Self: UIViewController {
    func load(resource: Resource)  {
        lineViewTwo.frame = self.view.frame
        self.view.addSubview(lineViewTwo)
        sharedWebservice.load(resource) { [weak self] result in
            print("-------------------\(result)")
            dispatch_async(dispatch_get_main_queue(), {
                if result != nil {
                    self?.lineViewTwo.fadeOut({ _ in
                        self?.lineViewTwo.removeFromSuperview()
                    })
                    guard let todayData = result else {return}
                    self?.configure(todayData)
                }
            })
        }
    }
}
let notificationKey = "back.toVC"

final class ApodViewController: UIViewController,Loading {
    @IBOutlet weak var todayTitle: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aboutMeButton: UIButton!
    @IBOutlet weak var aboutMeBackImage: UIImageView!
    var shareVideoLink = NSURL()//FIXME: figure out a different way
    var lineViewTwo = LineView()
    convenience init(day: Day){
        self.init()
        configure(day)
    }

    func configure(value: Day) {
        todayTitle.text = value.title
        todayTitle.sizeToFit()
        descriptionText.text = value.explanation

        if let todayMedia = configureMedia(value.url){
        switch value.media_type {
        case "image":
            todayImageView.image = todayMedia.image
        case "video":
            let videoView = UIWebView()
            videoView.frame = mediaView.bounds
            videoView.backgroundColor = UIColor.clearColor()
            self.mediaView.addSubview(videoView)
            videoView.loadRequest(NSURLRequest(URL:todayMedia.videoLink!))//FIXME: fix this
            shareVideoLink = todayMedia.videoLink!
        default: break
            }
        }
        aboutButtonAnimate()
    }

    func aboutButtonAnimate(){
        self.aboutMeBackImage.alpha = 0.05
        UIView.animateWithDuration(2.4, delay: 0, options: [.Repeat, .Autoreverse], animations: {[weak self] _ in
            self?.aboutMeBackImage.alpha = 1.0
            }, completion: { _ in
        })
    }
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        load(dayResource)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(aboutButtonAnimate), name: notificationKey, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureMedia(itsUrl: String) -> Content? {
        let todayContent = CreateContent.init(parseMedia: {u in
            let xImage = NSURL(string:u)
                .flatMap{ NSData(contentsOfURL: $0)}
                .flatMap{UIImage(data: $0)}
            let xURL = NSURL(string: u)
            return Content(image: xImage, videoLink: xURL)
        })
        return todayContent.parse(itsUrl)
    }
    
    @IBAction func shareButton(sender: UIButton) {//FIXME: refactor this
        print ("button share called")
        if let shareImage = todayImageView.image{
            let vc = UIActivityViewController(activityItems: [shareImage], applicationActivities: [])
            self.presentViewController(vc, animated: true, completion: {
                self.scrollView.backToOrigin()
                self.aboutButtonAnimate()
            })

        } else {
            let vc = UIActivityViewController(activityItems:[shareVideoLink], applicationActivities: [])
            self.presentViewController(vc, animated: true, completion: {
                self.scrollView.backToOrigin()
                self.aboutButtonAnimate()
            })
        }
        //aboutButtonAnimate
    }
    
    @IBAction func saveButton(sender: UIButton) {
        let testImage = todayImageView.image
                    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromImage(testImage!)
                     }, completionHandler: { success, error in
                            print("added image to album\(success)")
                            if !success { print("error creating asset: \(error)")}
                    })
        scrollView.backToOrigin()
    }
}
extension UIScrollView {
    func backToOrigin() {
        var bounds = self.bounds
        bounds.origin = CGPoint(x: 0, y: 0)
        self.setContentOffset(bounds.origin, animated: true)
    }
}
struct Content {
    let image: UIImage?
    let videoLink: NSURL?
}

struct CreateContent {
    let parse: String -> Content?
}
extension CreateContent {
    init(/*url:String,*/parseMedia: String -> Content?){
        self.parse = parseMedia
    }
}

