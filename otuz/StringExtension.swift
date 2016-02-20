//
//  StringExtension.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    
}