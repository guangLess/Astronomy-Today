//
//  MathVizPath.swift
//  APOD
//
//  Created by Guang on 8/5/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import UIKit

struct MathVizPath {
    let colour = UIColor.whiteColor()
    var pathMV = UIBezierPath()
    var ringCenter = CGPoint()
    var cardiodPath = UIBezierPath()
    init (center: CGPoint){
        self.ringCenter = center
        makeShape()
    }

    private func makeShape() {
        let x = 150.1
        let y = 130.5
        pathMV.moveToPoint(CGPoint(x: x, y: y))
        //pathMV.move(to: CGPoint(x: x, y: y))
        for i in 0...7 {
            let fi = Double(i)
            let exCosine = (2 * cos(fi/(2.0 * M_2_PI)))
            let eySine = (2 * sin(fi/(2.0*M_2_PI)))
            
            let ex = 60*( (exCosine ) - cos(fi/M_PI))
            let ey = 60*( (eySine ) + sin(fi/M_PI) + fi)
            
            let random = arc4random_uniform(9)
            let random2 = arc4random_uniform(160)
            let fex = CGFloat(ex + x)
            let fey = CGFloat(ey + y)
            pathMV.addCurveToPoint(CGPoint(x: fex, y: fey), controlPoint1:CGPoint(x: CGFloat(Float(random)+Float(x)), y: CGFloat(Float(random2)+Float(y))), controlPoint2: CGPoint(x: fex, y: fey))
        }
        pathMV.stroke()
        pathMV.lineWidth = 0.1
        colour.set()
    }
}
