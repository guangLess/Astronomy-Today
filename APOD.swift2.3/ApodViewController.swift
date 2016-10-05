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
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var copyright: UILabel!
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
        /*
         "error": {
         "code": "OVER_RATE_LIMIT",
         "message": "You have exceeded your rate limit. Try again later or contact us at https://api.nasa.gov/contact/ for assistance"
         }
         })
         */
        //self.todayImageViewOutlet.image = UIImage(data: try! Data(contentsOf: url)) "http://apod.nasa.gov/apod/image/1610/EagleNebula_Hendren_960.jpg"
        let imageData = NSData(contentsOfURL: NSURL(string:x.url)!)
//        _ = UIImage(data: imageData!)
        todayTitle.text = x.title
        descriptionText.text = x.explanation
        todayDate.text = x.date
        copyright.text = x.copyright
        //todayImageView.image  = UIImage(named: "noun_84091_cc")
        todayImageView.image = UIImage(data: imageData!)
    }
    
    @IBAction func shareButton(sender: UIButton) {
        print ("button share called")
        if let shareImage = UIImage(named: "noun_84091_cc"){
            let vc = UIActivityViewController(activityItems: [shareImage], applicationActivities: [])
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    @IBAction func saveButton(sender: UIButton) {
        
        let testImage = UIImage(named: "noun_95490_cc")
//        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ 
//            let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(testImage!)
//            let assetPlaceHolder = assetRequest.placeholderForCreatedAsset
//            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: assetCollection, assets: self.photosAsset)
//
//            
//        }) { (<#Bool#>, <#NSError?#>) in
//                //
//        }
        
        /*
         [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
         PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:<#your photo here#>];
         } completionHandler:^(BOOL success, NSError *error) {
         if (success) {
         <#your completion code here#>
         }
         else {
         <#figure out what went wrong#>
         }
         }];
         */
        
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(testImage!)
//            let assetPlaceholder = assetRequest.placeholderForCreatedAsset
//            let assetCollection:PHAssetCollection = fetchResult.firstObject;
//
//            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: PHAssetCollectionfetchResult.firstObject, assets: self.photosAsset)
  //          albumChangeRequest!.addAssets([assetPlaceholder!])
            }, completionHandler: { success, error in
                print("added image to album")
                print(error)
            })

    }
    

    
    
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
