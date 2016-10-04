//
//  ApodViewController.swift
//  APOD.swift2.3
//  Created by Guang on 10/3/16.
//  Copyright © 2016 Guang. All rights reserved.

import UIKit

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
        //self.todayImageViewOutlet.image = UIImage(data: try! Data(contentsOf: url)) "http://apod.nasa.gov/apod/image/1610/EagleNebula_Hendren_960.jpg"
        let imageData = NSData(contentsOfURL: NSURL(string:x.url)!)
        _ = UIImage(data: imageData!)
        //let image = UIImageView(image: todayImage)
        //bounds.size.width, bounds.size.height UIScreen.mainScreen().bounds
        //image.frame = CGRect(origin:CGPointMake(0, 0), size: CGSize(width:mediaView.bounds.size.width, height: mediaView.bounds.size.height))
        //image.contentMode = .ScaleAspectFill
        //mediaView.addSubview(image)
        
        
        todayTitle.text = x.title
        descriptionText.text = x.explanation
        todayDate.text = x.date
        copyright.text = x.copyright
        todayImageView.image = UIImage(data: imageData!)
        
        
//        todayDate.bringSubviewToFront(image)
//        copyright.bringSubviewToFront(image)
        //mediaView.sendSubviewToBack(todayDate)
        //mediaView.sendSubviewToBack(copyright)
        //image.sendSubviewToBack(mediaView)
        //image.sendSubviewToBack(mediaView)
        
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
