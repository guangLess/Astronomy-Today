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
    
    var videoLink = NSURL()//FIXME: figure out a different way ShareContent Struct with "message" and media.
    var lineViewTwo = LineView()
    var apodTitle = String()
    let wtext = Webservice()
    
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
        let element: (AnyObject) -> [AnyObject] = { content in
            return [self.apodTitle + "Astro Pic Of The Day @apod", content]
        }
        
        if let shareImage = todayImageView.image{
            share(element(shareImage))
        } else {
            share(element(videoLink))
        }
    }
    private func share(content: AnyObject){
        let vc = UIActivityViewController(activityItems: content as! [AnyObject], applicationActivities: [])
        self.presentViewController(vc, animated: true, completion: {
            self.scrollView.backToOrigin()
            self.aboutButtonAnimate()
        })
    }
    
    @IBAction func saveButton(sender: UIButton) {
        if let testImage = todayImageView.image {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(testImage)
                }, completionHandler: { success, error in
                    print("added image to album\(success)")
                    if !success { fatalError("error creating asset: \(error)")}
            })
        } else {
            let alertNote = "This video can not be downloaded."
            let xVC = UIAlertController(title: alertNote, message: "", preferredStyle: .Alert)
            self.presentViewController(xVC, animated: true, completion: nil)
            let action = UIAlertAction(title: "okey 💔", style: .Default, handler: {[weak self] _ in
                self?.scrollView.backToOrigin()
                })
            xVC.addAction(action)
        }
        //scrollView.backToOrigin()
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
        videoLink = NSURL(string:value.url)!
        apodTitle = value.title
        aboutButtonAnimate()
    }
}


