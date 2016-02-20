//
//  UIFontExtension.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

extension UIFont{
    
    convenience init?(latoRegularWithSize size: CGFloat) {
        self.init(name:"Lato-Regular",size:size)
    }
    
    convenience init?(latoBoldWithSize size: CGFloat) {
        self.init(name:"Lato-Bold",size:size)
    }
    
    convenience init?(latoLightWithSize size: CGFloat) {
        self.init(name:"Lato-Light",size:size)
    }
}