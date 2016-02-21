//
//  API.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class API {
    
    static let rootUrl = "https://otuz.herokuapp.com/"
    
    
    class func call(callType:String, functionName:String, params:NSMutableDictionary, completion:(result:APICallResult) -> Void){
        let endpointString = API.rootUrl + functionName;
        
        var allParams = params as! [String:AnyObject]
        //allParams["facebookUserId"] = Plist.sharedInstance.facebookUserId
        
        var encoding = ParameterEncoding.JSON
        var method = Method.POST
        
        if callType == "GET"{
            encoding = .URL
            method = .GET
        }else if callType == "PUT" {
            method = .PUT
        }else if callType == "DELETE" {
            method = .DELETE
        }
                
        Alamofire.request(method, endpointString, parameters: allParams, encoding: encoding, headers: nil).responseJSON {
            response in
            
            let resultObject = API.handleCallResult(functionName,response: response)
            
            completion(result: resultObject)
            
        }
        
    }
    
    
    class func handleCallResult(functionName:String?,response:Response<AnyObject, NSError>) -> APICallResult{
        
        let resultObject = APICallResult()
        
        if(response.result.isSuccess){
            let json = JSON(response.result.value!)
            
            if let error = json["error"].object as AnyObject? {
                if(!error.isKindOfClass(NSNull)){
                    let errorobj = APIError(j: JSON(error))
                    resultObject.error = errorobj
                    
                    if functionName != nil{
                        print("\(functionName!) get errror")
                    }
                    
                    if let code = errorobj.code{
                        print("Code:\(code)")
                    }
                    
                    if let errorMessage = errorobj.message{
                        print("Message:\(errorMessage)")
                    }
                    
                }
            }
            
            if let data = json["data"].object as AnyObject?{
                if(!data.isKindOfClass(NSNull)){
                    resultObject.data = JSON(data)
                }
            }
            
        }else{
            let error = APIError()
            error.code = -1
            error.message = "An error occurred, please check your internet connection"
            resultObject.error = error
        }
        
        return resultObject
        
    }
    
    
}