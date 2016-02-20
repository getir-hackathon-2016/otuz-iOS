//
//  FacebookConnect.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookConnect:NSObject {
    
    class func getPermissions() -> NSArray {
        return ["public_profile"]
    }
    
    class func sessionStateChanged(error:NSError? , completion: (error: Bool, errorMessage: String) -> Void) {
        
        print("sessionStateChanged")
        print(FBSDKAccessToken.currentAccessToken())
        
        if error != nil {
            completion(error: true, errorMessage: "Hata oluştu")
        }else{
            completion(error: false, errorMessage: "")
            
        }
        
    }
    
    class func dataRequest(completion: (data:FacebookUser,error:Bool) -> Void){
        
        let request = FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields":"name,id"])
        request.startWithCompletionHandler { (connection, result, error) -> Void in
            
            if error == nil {
                
                if let dataDictionary = result as! NSDictionary? {
                    let facebookUser = FacebookUser()
                    
                    if let name = dataDictionary.objectForKey("name") as! String?{
                        facebookUser.name = name
                    }
                    
                    if let facebookId = dataDictionary.objectForKey("id") as! String?{
                        facebookUser.id = facebookId
                    }
                    
                    if let accessToken = FBSDKAccessToken.currentAccessToken(){
                        
                        if let tokenString = accessToken.tokenString as String?{
                            facebookUser.accessToken = tokenString
                        }
                        
                    }
                    
                    completion(data: facebookUser, error: false)
                }
            }else{
                print("graph api error")
                completion(data: FacebookUser(), error: false)
            }
            
        }
        
    }
}