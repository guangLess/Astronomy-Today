//
//  AppExtentionProtocol.swift
//  APOD.swift2.3
//
//  Created by Guang on 10/4/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import UIKit

protocol ExtentionProtocol {
    func shareExtention(apod:Today)
}
//FIXME: add saved as PDF later
class AppExtention: ExtentionProtocol{
    
    func shareExtention(apod:Today) {
        
        /*
         let string: String = ...
         let URL: NSURL = ...
         
         let activityViewController = UIActivityViewController(activityItems: [string, URL], applicationActivities: nil)
         navigationController?.presentViewController(activityViewController, animated: true) {
         // ...
         }
         */
       // let activityViewController = UIActivityViewController(activityItems: apod, applicationActivities: nil)
    }
    

}