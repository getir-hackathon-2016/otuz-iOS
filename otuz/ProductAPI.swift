//
//  ProductAPI.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProductAPI{
    
    class func getProduct(barcodeNumber:String,completion:(result:APICallResult,product:Product?) -> Void){
        
        let funcName = "products/\(barcodeNumber)"
        
        let params = NSMutableDictionary()
        
        API.call("GET", functionName: funcName, params: params) {
            (result) -> Void in
            
            var product:Product? = nil
            
            if result.error == nil {
                if let data = result.data{
                    if let dataObj = data.object as AnyObject?{
                        if !dataObj.isKindOfClass(NSNull){
                            product = Product(j: JSON(dataObj))
                        }
                    }
                }
            }
            
            completion(result: result, product: product)
            
        }
        
    }
    
}