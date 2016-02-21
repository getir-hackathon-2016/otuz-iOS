//
//  ErrorBanner.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import UIKit

class ErrorBanner: NSObject {
    
    static var activeBanner:Banner?
    
    class func handleError(error:APIError){
        
        if let msg = error.message {
            
            ErrorBanner.dismissActiveBanner()
            let banner = Banner(title: msg.localized)
            activeBanner = banner
            banner.show(duration:3)
        }
        
    }
    
    class func dismissActiveBanner(){
        
        if activeBanner != nil {
            activeBanner!.dismiss()
        }
        
    }
    
    class func standartBanner() -> Banner {
        
        ErrorBanner.dismissActiveBanner()
        
        let banner = Banner(title: "FILL_ALL_FIELD_ERROR".localized, didTapBlock: nil)
        
        activeBanner = banner
        
        return banner
    }
    
    class func unknownErrorBanner() -> Banner {
        
        ErrorBanner.dismissActiveBanner()
        
        let banner = Banner(title: "GENERAL_ERROR".localized, didTapBlock: nil)
        
        activeBanner = banner
        
        return banner
    }
}
