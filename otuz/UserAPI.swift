//
//  UserAPI.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserAPI{
    
    class func facebookConnect(facebookUser:FacebookUser,completion:(result:APICallResult,user:User?) -> Void){
        
        let funcName = "users"
        
        let params = NSMutableDictionary()
        params["name"] = facebookUser.name
        params["facebookUserId"] = facebookUser.id
        print(params)
        API.call("POST", functionName: funcName, params: params) {
            (result) -> Void in
            
            var user:User? = nil
            
            if result.error == nil {
                if let data = result.data{
                    print(data)
                    if let dataObj = data.object as AnyObject?{
                        if !dataObj.isKindOfClass(NSNull){
                            user = User(j: JSON(dataObj))
                        }
                    }
                }
            }
            
            completion(result: result, user: user)
            
        }
        
    }
}