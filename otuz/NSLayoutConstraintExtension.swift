//
//  NSLayoutConstraintExtension.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    class func defaultConstraintsWithVisualFormat(format: String, options: NSLayoutFormatOptions = .DirectionLeadingToTrailing, metrics: [String: AnyObject]? = nil, views: [String: AnyObject] = [:]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views)
    }
}