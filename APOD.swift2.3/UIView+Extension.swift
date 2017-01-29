//
//  UIView+Extension.swift
//  APOD.swift2.3
//
//  Created by Guang on 11/7/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit
/*
extension UIView {
    public func constrainEqual(attribute: NSLayoutAttribute, to: AnyObject, _ toAttribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: to, attribute: toAttribute, multiplier: multiplier, constant: constant)
            ]
        )
    }
    public func constrainEdges(toMarginOf view: UIView) {
        constrainEqual(.Top, to: view, .TopMargin)
        constrainEqual(.Leading, to: view, .LeadingMargin)
        constrainEqual(.Trailing, to: view, .TrailingMargin)
        constrainEqual(.Bottom, to: view, .BottomMargin)
    }
}
*/


extension UIScrollView {
    func backToOrigin() {
        var bounds = self.bounds
        bounds.origin = CGPoint(x: 0, y: 0)
        self.setContentOffset(bounds.origin, animated: true)
    }
}

