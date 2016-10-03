//
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
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.black
        // WHY protocols can not store or contain storage ?
        //FIXME: figure out why the struc has to be called after the previous methods.
        drawPathElements()
    }
    //MARK: drawElements
    func drawPathElements(){
        testPath = creatSimpleShapeReturn(faceCenter, radius: 30, startAngle: 0, endAngle: CGFloat(M_PI/3), clockwise: false, lineWidth: 1.0, pathColor: UIColor.white)
        outterRing = creatSimpleShapeReturn(faceCenter, radius: faceRadius, startAngle: CGFloat(M_PI/3), endAngle: CGFloat(2*M_PI), clockwise: true, lineWidth: 0.2, pathColor: UIColor.white)
        _ = MathVizPath(center: faceCenter)
        drawRadialGradient()
    }
    func drawRadialGradient(){
        let context = UIGraphicsGetCurrentContext()
        let locations: [CGFloat] = [0.0, 1.0]
        let colorts = [UIColor.yellow.cgColor, UIColor.clear.cgColor]
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorspace, colors: colorts as CFArray, locations: locations)
        context?.drawRadialGradient(gradient!, startCenter: faceCenter, startRadius: CGFloat(0), endCenter: faceCenter, endRadius: CGFloat(160), options: .drawsAfterEndLocation)
    }
    
    //MARK: touch event
    var isMiddleLocationTapped = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchPoint = touches.first {
            let touchLocation = touchPoint.location(in: self)
            isMiddleLocationTapped = testPath.contains(touchLocation)
            if isMiddleLocationTapped == true {
                configerTimer()
                blink(testPath, blinkColor: UIColor.yellow)
            }
            print(touchLocation)
        }
    }
    
    var timeSequence = 0.1
    var timeSineValue: Double = 1
    var timer = Timer()
    var timerState = true
    func configerTimer(){
        if timerState == false {
            timer.invalidate()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector:#selector(self.timerMachin), userInfo: nil, repeats: true)
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
        animation.path = testPath.cgPath
        
        let dot = UIView()
        let size = CGSize(width: 4, height: 4)
        dot.frame = CGRect(origin: faceCenter, size: size)
        dot.backgroundColor = UIColor.yellow
        self.addSubview(dot)
        dot.layer.add(animation, forKey: nil)
    }
}
