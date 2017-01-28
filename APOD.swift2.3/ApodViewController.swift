//
//  ApodViewController.swift
//  APOD.swift2.3
//  Created by Guang on 10/3/16.
//  Copyright © 2016 Guang. All rights reserved.
import UIKit
import Photos

let notificationKey = "back.toVC"

final class ApodViewController: UIViewController, LoadingApod {
    
    @IBOutlet weak var todayTitle: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aboutMeButton: UIButton!
    @IBOutlet weak var aboutMeBackImage: UIImageView!
    
    var apodToday = [Day]()//TIXME:why Day() will not work? Or make it into a call back?
    
    var shareVideoLink = NSURL()//FIXME: figure out a different way
    var lineViewTwo = LineView() //FIXME: maybe a call back
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lineViewTwo.frame = self.view.frame
        self.view.addSubview(self.lineViewTwo)

        load(dayResource) { [weak self] (dayContent) in
            self?.apodToday.append(dayContent)
                        dispatch_async(dispatch_get_main_queue(), {
            self?.lineViewTwo.fadeOut({ _ in
                self?.lineViewTwo.removeFromSuperview()
            })
            //guard let content = dayContent else {fatalError("can not get APOD")}
            self?.configure(dayContent)
            })
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(aboutButtonAnimate), name: notificationKey, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        aboutButtonAnimate()
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
   //FIXME: why@objc
   @objc private func aboutButtonAnimate(){
        self.aboutMeBackImage.alpha = 0.05
        UIView.animateWithDuration(2.4, delay: 0, options: [.Repeat, .Autoreverse], animations: {[weak self] _ in
            self?.aboutMeBackImage.alpha = 1.0
            }, completion: { _ in
        })
    }
    
   private func configure(value: Day) {
        todayTitle.text = value.title
        todayTitle.sizeToFit()
        descriptionText.text = value.explanation
        let mediaType = Media(type: value.media_type, url: value.url)
        mediaType.configurTo(mediaView, todayImageView: todayImageView)
        aboutButtonAnimate()
    }

}

struct Media {
    let type: String
    let url: String
    let imageType: (String) -> (UIImage?) = { url in
        return NSURL(string:url)
            .flatMap{NSData(contentsOfURL: $0)}
            .flatMap{UIImage(data: $0)}
    }
    let videoType: (UIView, String) -> () = { view, url  in
        let videoView = UIWebView()
        videoView.frame = view.bounds
        videoView.backgroundColor = UIColor.clearColor()
        view.addSubview(videoView)
        videoView.loadRequest(NSURLRequest(URL:NSURL(string: url)!))
    }
}
extension Media  {
    func configurTo(mediaView: UIView, todayImageView: UIImageView){
        switch self.type {
        case "image" :
            todayImageView.image = imageType(self.url)
            print("x image")
        case "video" :
            print("x video")
//            let videoView = UIWebView()
//            videoView.frame = mediaView.bounds
//            videoView.backgroundColor = UIColor.clearColor()
//            mediaView.addSubview(videoView)
//            videoView.loadRequest(NSURLRequest(URL:NSURL(string: self.url)! ))//FIXME: fix this
           // shareVideoLink = todayMedia.videoLink!
            videoType(mediaView, self.url)
            
        default: "other"
        }
    }
}


