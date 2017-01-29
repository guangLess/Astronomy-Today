//
//  UIView+Extension.swift
//  APOD.swift2.3
//
//  Created by Guang on 11/7/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit

extension UIScrollView {
    func backToOrigin() {
        var bounds = self.bounds
        bounds.origin = CGPoint(x: 0, y: 0)
        self.setContentOffset(bounds.origin, animated: true)
    }
}
