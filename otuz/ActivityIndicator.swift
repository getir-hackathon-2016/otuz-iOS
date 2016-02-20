//
//  ActivityIndicator.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator{
    
    class func start(view: UIView) -> UIActivityIndicatorView{
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.center = view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        actInd.color = UIColor.blackColor()
        view.addSubview(actInd)
        actInd.startAnimating()
        
        return actInd
    }
    
    class func stop(actInd: UIActivityIndicatorView) {
        actInd.stopAnimating()
        actInd.removeFromSuperview()
    }
    
}