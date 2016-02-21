//
//  LabelInset.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

class LabelInset: UILabel {
    
    override func drawRect(rect: CGRect) {
        let inset = UIEdgeInsetsMake(0, 5, 0,5)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, inset))
    }
    
}
