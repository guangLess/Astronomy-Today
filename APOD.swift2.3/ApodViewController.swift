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
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var spin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //spin.addSubview(UIImageView(image: UIImage(named: "x.png")).contentMode.rawValue = 1)
        let bimage = UIImageView(image: UIImage(named: "PM.jpg"))
        let or = spin.frame.origin
//        spin.transform = CGAffineTransformMakeScale(0.5, 0.5)
//        let size = spin.bounds.size

        bimage.frame = CGRect(origin: or, size: CGSize(width: 100, height: 100))
        bimage.clipsToBounds = true
        spin.addSubview(bimage)
        bimage.contentMode = .ScaleAspectFit
        spin.startAnimating()
        let lineViewTwo = LineView(frame: view.frame)
        view.addSubview(lineViewTwo)

        apodNetwork.getTodayInfo { [weak self] x in
            dispatch_async(dispatch_get_main_queue(), {
                    print(x)
                self?.spin.stopAnimating()
                lineViewTwo.fadeOut({ _ in
                    lineViewTwo.removeFromSuperview()
                })
                self?.updateUI(x)
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateUI(x:Today){
        todayTitle.text = x.title
        descriptionText.text = x.explanation
        let xImage = NSURL(string: x.url)
            .flatMap{ NSData(contentsOfURL: $0)}
            .flatMap{UIImage(data: $0)}
        todayImageView.image = xImage ?? UIImage(named: "x.png")
    }
    
    @IBAction func shareButton(sender: UIButton) {
        print ("button share called")
        if let shareImage = UIImage(named: "x.png"){
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
