//
//  ApodViewController.swift
//  APOD.swift2.3
//  Created by Guang on 10/3/16.
//  Copyright © 2016 Guang. All rights reserved.
import UIKit
import Photos



let sharedWebservice = Webservice()


protocol Loading {
    var lineViewTwo : LineView {get}
    func configure(value: Day)
    
}
extension Loading where Self: UIViewController {
    
    func load(resource: Resource)  {
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
                    self?.configure(todayData)
                }
            })
        }
    }
}






final class ApodViewController: UIViewController,Loading {
    //lazy var apodNetwork: NetworkController = ApodNetwork()
    @IBOutlet weak var todayTitle: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aboutMeButton: UIButton!
    
    /*
     let url = NSURL(string: "http://localhost:8000/episode.json")!
     let episodeResource = Resource<Episode>(url: url, parseJSON: { anyObject in
     (anyObject as? JSONDictionary).flatMap(Episode.init)
     })
     
     */
    
    
    var lineViewTwo = LineView()
    convenience init (resource: Resource) {
        self.init()
        load(resource)
    }
    
    func configure(value: Day) {
        todayTitle.text = value.title
        todayTitle.sizeToFit()
        descriptionText.text = value.explanation
        showMedia(value.media_type, itsUrl: value.url)
    }

    let defaultImage = UIImage(named: "x.png")
    //var todayData = Day(dictionary: [:])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let lineViewTwo = LineView(frame: view.frame)
        view.addSubview(lineViewTwo)
        
        Webservice().load(Day.all) { result in
            print("-------------------\(result)")
            dispatch_async(dispatch_get_main_queue(), { 
                if let todayData = result {
                    lineViewTwo.fadeOut({ _ in
                        lineViewTwo.removeFromSuperview()
                    })
                    self.updateUI(todayData)
                }
            })
        }*/
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        //aboutMeButton.setNeedsDisplay()
//        //aboutMeButton.awakeFromNib()
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*func updateUI(x:Day){
        todayTitle.text = x.title
        todayTitle.sizeToFit()
        descriptionText.text = x.explanation
        showMedia(x.media_type, itsUrl: x.url)
        // show media type
    }*/
    

    
    func showMedia(media:String, itsUrl: String) {

        let todayContent = CreateContent.init(/*url: x.url,*/ parseMedia: {u in
            let xImage = NSURL(string:u)
                .flatMap{ NSData(contentsOfURL: $0)}
                .flatMap{UIImage(data: $0)}
            let xURL = NSURL(string: u)
            return Content(image: xImage, videoLink: xURL)
        })
        
        let parseResult = todayContent.parse(itsUrl)
        print(parseResult)
        
        if (media == "video") {
            let videoView = UIWebView()
            videoView.frame = mediaView.bounds
            videoView.backgroundColor = UIColor.clearColor()
            self.mediaView.addSubview(videoView)
            //            guard let videoURL = NSURL(string: x.url)
            //                else {return}
            videoView.loadRequest(NSURLRequest(URL:(parseResult?.videoLink)!))
        } else {
            //            let xImage = NSURL(string: x.url)
            //                .flatMap{ NSData(contentsOfURL: $0)}
            //                .flatMap{UIImage(data: $0)}
            //            todayImageView.image = xImage ?? defaultImage
            todayImageView.image = parseResult?.image
            //FIXME:change it to a switch
        }
    }
    
    @IBAction func shareButton(sender: UIButton) {
        print ("button share called")
        if let shareImage = todayImageView.image{
            let vc = UIActivityViewController(activityItems: [shareImage], applicationActivities: [])
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

//struct Media {
//    let videoURL : NSString -> NSURL?
//    let imageURL: NSString -> UIImage?
//}
//
//extension Media {
//    
//    init(videoURL: NSString, image: NSString -> UIImage?){
//        self.videoURL = { x in
//                return NSURL(string: x as String)
//        }
//         self.imageURL = { x in
//            let xImage = NSURL(string: x as String)
//                .flatMap{ NSData(contentsOfURL: $0)}
//                .flatMap{UIImage(data: $0)}
//            return xImage
//        }
//    }
//}

//struct MediaType<A> {
//    
//    let mediaType : String
//    
//    func processMedia<M>() -> Content {
//        switch mediaType {
//        case "image":
//            let xImage = NSURL(string:mediaType)
//                .flatMap{ NSData(contentsOfURL: $0)}
//                .flatMap{UIImage(data: $0)}
//            return xImage
//        default:
//            
//        }
//    }
//}

struct Content {
    let image: UIImage?
    let videoLink: NSURL?
}

struct CreateContent {
    //let url: String
    let parse: String -> Content?
}
extension CreateContent {
    init(/*url:String,*/parseMedia: String -> Content?){
        self.parse = parseMedia
    }
}




















