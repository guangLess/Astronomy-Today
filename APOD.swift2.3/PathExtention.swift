//
//  PathExtention.swift
//  APOD
//
//  Created by Guang on 8/16/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import UIKit

protocol Shapeble { }
extension Shapeble where Self: UIView {
    func creatSimpleShapeReturn(arcCenter: CGPoint = CGPoint(x: 0, y: 0), radius: CGFloat = 0.0, startAngle: CGFloat = 0.0, endAngle: CGFloat = 0.0, clockwise: Bool = true,
                          lineWidth: CGFloat = 0.0, pathColor: UIColor) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        path.lineWidth = lineWidth
        pathColor.set()
        path.stroke()
        return path
    }
}
protocol CanBlink { }
extension CanBlink where Self: UIView {
    func blink(blinkPath : UIBezierPath, blinkColor: UIColor) {
        let blinkPathLayer = CAShapeLayer()
        blinkPathLayer.path = blinkPath.CGPath
        blinkPathLayer.fillColor = blinkColor.CGColor
        blinkPathLayer.opacity = 0
        self.layer.addSublayer(blinkPathLayer)
        let blinkAnimation = CAKeyframeAnimation(keyPath: "opacity")
        blinkAnimation.values = [0.0, 1.0,1.0,1.0,1.0,1.0,0.0]
        blinkAnimation.duration = 1
        
        blinkPathLayer.addAnimation(blinkAnimation, forKey: "blinkAnimation")
    }
    //thickness
    func blinkStock(path: UIBezierPath){
        let blinkPathLayer = CAShapeLayer()
        blinkPathLayer.path = path.CGPath
        blinkPathLayer.strokeStart = 0
        blinkPathLayer.strokeEnd = 3
        self.layer.addSublayer(blinkPathLayer)
        let blinkAnimation = CAKeyframeAnimation(keyPath: "Stroke")
        blinkAnimation.values = [0.0, 1.0,1.0,1.0,1.0,1.0,0.0]
        blinkAnimation.duration = 1
        blinkPathLayer.addAnimation(blinkAnimation, forKey: "blinkAnimation")
    }
}


