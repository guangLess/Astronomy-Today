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
        //aboutText.text = text
        //aboutMe.text = aboutMeText
        aboutText.text = contet.init().text
        aboutMe.text = contet.init().aboutMeText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(sender: AnyObject) {
            //add animation
        
        UIView.animateWithDuration(2, animations: { 
            self.view.alpha = 0.0
            }) { _ in
                //self.removeFromParentViewController()
                //self.navigationController?.popViewControllerAnimated(false)
                self.dismissViewControllerAnimated(false, completion: nil)
        }
            //self.view.alpha = 0.0
    }
}

struct contet {
    let text:String = "Astronomy Picture of the Day: Each day a different image or photograph of our fascinating universe is featured from NASA, along with a brief explanation written by a professional astronomer.\nhttps://apod.nasa.gov/"
    let aboutMeText:String = "About me: I am an artist using code to visualize mathematic equations that I created from the mist of love for math and abstract things.\nhttps://www.guangless.com\nNot affiliated with NASA."
}
