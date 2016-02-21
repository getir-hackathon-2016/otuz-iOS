//
//  OrderAPI.swift
//  otuz
//
//  Created by Emre Berk on 21/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderAPI{

    class func order(facebookUserId:String,deliveryDate:NSDate,completion:(result:APICallResult) -> Void){
        
        let funcName = "orders"
        
        let params = NSMutableDictionary()
        params["facebookUserId"] = facebookUserId
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
        if let dateString = formatter.stringFromDate(deliveryDate) as String?{
            params["deliveryDate"] = dateString
        }
        
        API.call("POST", functionName: funcName, params: params) {
            (result) -> Void in
            
            completion(result: result)
            
        }
        
    }
}