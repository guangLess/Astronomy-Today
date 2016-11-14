//
//  ApodViewController.swift
//  APOD.swift2.3
//  Created by Guang on 10/3/16.
//  Copyright © 2016 Guang. All rights reserved.
import UIKit
import Photos

let aurl = NSURL(string: "https://api.nasa.gov/planetary/apod?api_key=XQCVvM7SkdY4qrvNXSH00TkO6wRpsgPQyYDeA09T")!
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
        self.aboutMeBackImage.alpha = 1.0
        UIView.animateWithDuration(2.4, delay: 0, options: [.Repeat, .Autoreverse], animations: {[weak self] _ in
            self?.aboutMeBackImage.alpha = 0.05
            }, completion: { _ in
                //self.aboutMeBackImage.stopAnimating()
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
            })
        } else {
            let vc = UIActivityViewController(activityItems:[shareVideoLink], applicationActivities: [])
            self.presentViewController(vc, animated: true, completion: {
                self.scrollView.backToOrigin()
            })
        }
    }
    @IBAction func saveButton(sender: UIButton) {
        let testImage = todayImageView.image 
        //_:String = "Camera Roll"
        //let options:PHFetchOptions = PHFetchOptions()
        //options.predicate = NSPredicate(format: "title = %@","Camera Roll")
        //let userAlbums = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumUserLibrary, options: nil)
        //let collection = userAlbums.firstObject as! PHAssetCollection
        //print(collection)
                    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromImage(testImage!)
                       /*
                        let assetPlaceholder = assetRequest.placeholderForCreatedAsset
                        let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: collection)
                        albumChangeRequest!.addAssets([assetPlaceholder!] as NSArray)
                        print(assetPlaceholder?.localIdentifier)
 */
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

/*struct AboutButtonStruct {
//    func aboutBAnimate(vc:UIView, completion: (Bool)->Void){
//        vc.alpha = 0.85
//        UIView.animateWithDuration(3.0, delay: 0, options: [.Repeat, .Autoreverse], animations: { [unowned vc] _ in
//            vc.alpha = 0.13
//            }, completion: completion)
//    }
    
    func aboutBAnimate(vc:UIView /*,completion: (Bool)->Void*/){
        vc.alpha = 0.85
        UIView.animateWithDuration(3.0, delay: 0, options: [.Repeat, .Autoreverse], animations: { [unowned vc] _ in
            vc.alpha = 0.13
            }, completion: nil)
    }
}*/
/*
final class LoadingViewController: UIViewController {
    var lineViewTwo = LineView()

    init(resource: Resource, build: Day -> UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        lineViewTwo.frame = self.view.frame
        self.view.addSubview(lineViewTwo)
        sharedWebservice.load(Day.all) { [weak self] result in
            print("-------------------\(result)")
            dispatch_async(dispatch_get_main_queue(), {
                if result != nil {
                    self?.lineViewTwo.fadeOut({ _ in
                        self?.lineViewTwo.removeFromSuperview()
                    })
                    guard let todayData = result else {return}
                    let viewController = build(todayData)
                    self?.add(viewController)
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(content: UIViewController) {
        addChildViewController(content)
        view.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.constrainEdges(toMarginOf: view)
        content.didMoveToParentViewController(self)
    }

}
*/

