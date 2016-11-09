//
//  AboutViewController.swift
//  APOD.swift2.3
//
//  Created by Guang on 10/20/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var aboutMe: UITextView!
    //    let text:String = "Astronomy Picture of the Day: Each day a different image or photograph of our fascinating universe is featured from NASA, along with a brief explanation written by a professional astronomer.\nhttps://apod.nasa.gov/"
    //    let aboutMeText:String = "About me: I am an artist using code to visualize mathematic equations that I created from the mist of love for math and abstract things.\nhttps://www.guangless.com\nNot affiliated with NASA."
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //        AboutButtonStruct.init().aboutBAnimate(self.backButton) { _ in
        //            return true
        //        }
        aboutText.text = contet.init().text
        aboutText.maximumZoomScale = 1
        aboutText.minimumZoomScale = 0.7
        aboutMe.text = contet.init().aboutMeText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func back(sender: AnyObject) {
        
        UIView.animateWithDuration(2, animations: {
            self.view.alpha = 0.0
        }) { _ in
            self.dismissViewControllerAnimated(false, completion: { _ in
                NSNotificationCenter.defaultCenter().postNotificationName(notificationKey, object: nil)
            })
        }
    }
}

struct contet {
    let text:String = "Astronomy Picture of the Day: Each day a different image or photograph of our fascinating universe is featured from NASA, along with a brief explanation written by a professional astronomer.\nhttps://apod.nasa.gov/"
    let aboutMeText:String = "About me: I am an artist using code to visualize mathematic equations that I created from the mist of love for math and abstract things.\nhttps://www.guangless.com\nNot affiliated with NASA."
}
