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
    
    class func getUser(facebookId:String,completion:(result:APICallResult,user:User?) -> Void){
        
        let funcName = "users/\(facebookId)"
        let params = NSMutableDictionary()
        
        API.call("GET", functionName: funcName, params: params) {
            (result) -> Void in
            
            var user:User? = nil
            
            if result.error == nil {
                if let data = result.data{
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
    
    class func facebookConnect(facebookUser:FacebookUser,completion:(result:APICallResult,user:User?) -> Void){
        
        let funcName = "users"
                
        let params = NSMutableDictionary()
        params["name"] = facebookUser.name
        params["facebookUserId"] = facebookUser.id
        
        API.call("POST", functionName: funcName, params: params) {
            (result) -> Void in
            
            var user:User? = nil
            
            if result.error == nil {
                if let data = result.data{
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
    
    class func saveProduct(facebookUserId:String,productId:String,completion:(result:APICallResult,user:User?) -> Void){
        
        let funcName = "users/products"
        
        let params = NSMutableDictionary()
        params["facebookUserId"] = facebookUserId
        params["productId"] = productId
        
        API.call("POST", functionName: funcName, params: params) {
            (result) -> Void in
            
            var user:User? = nil
            
            if result.error == nil {
                if let data = result.data{
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
    
    class func updateAddress(address:Address,facebookId:String,completion:(result:APICallResult,user:User?) -> Void){
        
        let funcName = "users/address"
        
        let params = NSMutableDictionary()
        params["address"] = address.toDictionary()
        params["facebookUserId"] = facebookId

        API.call("POST", functionName: funcName, params: params) {
            (result) -> Void in
            
            var user:User? = nil
            
            if result.error == nil {
                if let data = result.data{
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
    
    class func changeProductQuantity(facebookId:String,quantity:Int,productId:String,completion:(result:APICallResult,user:User?) -> Void){
        
        let funcName = "users/products/\(productId)"
        
        let params = NSMutableDictionary()
        params["quantity"] = quantity
        params["facebookUserId"] = facebookId
        
        API.call("POST", functionName: funcName, params: params) {
            (result) -> Void in
            
            var user:User? = nil
            
            if result.error == nil {
                if let data = result.data{
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