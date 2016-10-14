//
//  ApodViewController.swift
//  APOD.swift2.3
//  Created by Guang on 10/3/16.
//  Copyright © 2016 Guang. All rights reserved.

import UIKit
import Photos

class ApodViewController: UIViewController {
    lazy var apodNetwork: NetworkController = ApodNetwork()
    @IBOutlet weak var todayTitle: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    //@IBOutlet weak var todayDate: UILabel!
    //@IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var todayImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apodNetwork.getTodayInfo { x in
            dispatch_async(dispatch_get_main_queue(), {
                    print(x)
                self.updateUI(x)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func updateUI(x:Today){
        //FIXME: use a whole dataset for none URLsession
        //self.todayImageViewOutlet.image = UIImage(data: try! Data(contentsOf: url)) "http://apod.nasa.gov/apod/image/1610/EagleNebula_Hendren_960.jpg"

        let imageData = NSData(contentsOfURL: NSURL(string:x.url)!)
        todayTitle.text = x.title
        descriptionText.text = x.explanation
        //todayDate.text = x.date
        //copyright.text = x.copyright
        //todayImageView.image  = UIImage(named: "x.png")
        todayImageView.image = UIImage(data: imageData!)
    }
    @IBAction func shareButton(sender: UIButton) {
        print ("button share called")
        if let shareImage = UIImage(named: "x.png"){
            let vc = UIActivityViewController(activityItems: [shareImage], applicationActivities: [])
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    @IBAction func saveButton(sender: UIButton) {
        let testImage = UIImage(named: "x.png")
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
    }
}
