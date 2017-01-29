//
//  ApodViewController.swift
//  APOD.swift2.3
//  Created by Guang on 10/3/16.
//  Copyright © 2016 Guang. All rights reserved.
import UIKit
import Photos

let notificationKey = "back.toVC"
enum ShareMedia {
    case image
    case video
}

final class ApodViewController: UIViewController, LoadingApod {
    @IBOutlet weak var todayTitle: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aboutMeButton: UIButton!
    @IBOutlet weak var aboutMeBackImage: UIImageView!
    
    var shareVideoLink = NSURL()//FIXME: figure out a different way
    var lineViewTwo = LineView() //FIXME: maybe a call back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lineViewTwo.frame = self.view.frame
        self.view.addSubview(self.lineViewTwo)

        load(dayResource) { [weak self] (dayContent) in
            dispatch_async(dispatch_get_main_queue(), {
                self?.configure(dayContent)
                self?.lineViewTwo.removeWithFadeOut()
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
        //aboutButtonAnimate()
    }
    
    @IBAction func saveButton(sender: UIButton) {
        let testImage = todayImageView.image
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(testImage!)
            }, completionHandler: { success, error in
                print("added image to album\(success)")
                if !success { fatalError("error creating asset: \(error)")}
        })
        scrollView.backToOrigin()
    }
   //FIXME: why@objc
    @objc private func aboutButtonAnimate(){
        self.aboutMeBackImage.alpha = 0.05
        UIView.animateWithDuration(2.4, delay: 0, options: [.Repeat, .Autoreverse], animations: {[weak self] _ in
            self?.aboutMeBackImage.alpha = 1.0
            }, completion: nil)
    }
   private func configure(value: Day) {
        todayTitle.text = value.title
        todayTitle.sizeToFit()
        descriptionText.text = value.explanation
        let todayMedia = Media(type: value.media_type, url: value.url)
        todayMedia.configurTo(mediaView, todayImageView: todayImageView)
    
        aboutButtonAnimate()
    }
    
    func share() -> Void{
        let vc = UIActivityViewController(activityItems: ["hello"], applicationActivities: [])
        self.presentViewController(vc, animated: true, completion: {
            self.scrollView.backToOrigin()
        })
        
    }   
}
/*
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
 */




