//  LineView.swift
//  APOD
//
//  Created by Guang on 8/2/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit
import Foundation
//TODO: ttps://realm.io/news/richard-fox-casting-swift-2/ try extions.
class LineView: UIView, Shapeble, CanBlink{
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    var scale : CGFloat = 0.9 {didSet{setNeedsDisplay()}}
    var colour : UIColor = UIColor.whiteColor() {didSet{ setNeedsDisplay() }}
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    var testPath = UIBezierPath()
    var outterRing = UIBezierPath()
    var mathPath = UIBezierPath()
    
    override func drawRect(rect: CGRect){
        self.backgroundColor = UIColor.blackColor()
        // WHY protocols can not store or contain storage ?
        //FIXME: figure out why the struc has to be called after the previous methods.
        drawPathElements()
        configerTimer()

    }
    //MARK: drawElements
    func drawPathElements(){
        testPath = creatSimpleShapeReturn(faceCenter, radius: 30, startAngle: 0, endAngle: CGFloat(M_PI/3), clockwise: false, lineWidth: 1.0, pathColor: UIColor.whiteColor())
        outterRing = creatSimpleShapeReturn(faceCenter, radius: faceRadius, startAngle: CGFloat(M_PI/3), endAngle: CGFloat(2*M_PI), clockwise: true, lineWidth: 0.2, pathColor: UIColor.whiteColor())
        print(timeSequence)
        //mathPath = MathVizPath(center: faceCenter, motion: Float(timeSequence)).pathMV
        drawRadialGradient()
    }
    func drawRadialGradient(){
        let context = UIGraphicsGetCurrentContext()
        let locations: [CGFloat] = [0.0, 1.0]
        let colorts = [UIColor.yellowColor().CGColor, UIColor.clearColor().CGColor]
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColors(colorspace, colorts, locations)
        CGContextDrawRadialGradient(context!, gradient!, center, 0, center, CGFloat(160), .DrawsAfterEndLocation)
    }
    //MARK: touch event
    var isMiddleLocationTapped = false
    var isMathDrawingTapped = true
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchPoint = touches.first {
            let touchLocation = touchPoint.locationInView(self)  //touchPoint.location(in: self)
            isMiddleLocationTapped = testPath.containsPoint(touchLocation)//testPath.contains(touchLocation)
            if isMiddleLocationTapped == true {
                timer.invalidate()
                configerTimer()
                blink(testPath, blinkColor: UIColor.yellowColor())
            }
//            isMathDrawingTapped = mathPath.containsPoint(touchLocation)
//            if isMathDrawingTapped == true {
//                //blinkStock(mathPath)
//            }
            print(touchLocation)
        }
    }
   var timeSequence = 0.1
    var timeSineValue: Double = 1
    var timer = NSTimer()
    var timerState = true
    func configerTimer(){
        if timerState == false {
            timer.invalidate()
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector:#selector(self.timerMachin), userInfo: nil, repeats: true)
            timer.fire()
        }
        timerState = !timerState
    }
    func timerMachin() {
        timeSineValue += 1/M_2_PI
        if timeSineValue == M_2_PI {
            timeSineValue = 1/M_2_PI
        }
        timeSequence += 0.1
        if timeSequence == 3 {
            timeSequence = 0.01
        }
        
        let r = Double(faceRadius) * cos(timeSineValue) * sin(timeSequence)
        let tempT = CGFloat(r)
        let testPath = UIBezierPath(arcCenter: faceCenter, radius: tempT, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI/3), clockwise: false)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 4
        animation.repeatCount = 1
        animation.path = testPath.CGPath
        let dot = UIView()
        let size = CGSize(width: 4, height: 4)
        dot.frame = CGRect(origin: faceCenter, size: size)
        dot.backgroundColor = UIColor.yellowColor()
        self.addSubview(dot)
        dot.layer.addAnimation(animation, forKey: nil)
    }
}


//UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//    self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
//    }, completion: nil)

extension UIView {
    func fadeOut(completion:Bool -> ()){
        UIView.animateWithDuration(5.5, animations: {
            self.alpha = 0.0 }) { _ in
                completion(true)
        }
//        UIView.animateWithDuration(9.5,) {
//            self.alpha = 0.0
//        },
    }
}
