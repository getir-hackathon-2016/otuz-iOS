//
//  NavigationHelper.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

class NavigationHelper{
    
    static let blankTitleBackBarItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    class func titleAttributes() -> [String:AnyObject]? {
        return [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Lato-Bold", size: 18)!]
    }

}