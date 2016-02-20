//
//  User.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import SwiftyJSON

func hasCurrentUser() -> Bool {
    return User.currentUser != nil
}

class User: NSObject{
    
    static var currentUser:User?{
        willSet {
            if let newUser = newValue {
                if let facebookId = newUser.facebookUserId{
                    Plist.sharedInstance.facebookUserId = facebookId
                }
            }
        }
    }
    
    var facebookUserId:String!
    var name:String!
    var address:Address?
    var registeredAt:NSDate?
    var products:[Product] = []
    
    init(j: JSON){
        
        self.facebookUserId = j["facebookUserId"].string
        self.name = j["name"].string
        
        self.products = []
        if let productArray = j["products"].array{
            for(var i=0; i<productArray.count; i++){
                if let aProduct = productArray[i].object as AnyObject?{
                    if !aProduct.isKindOfClass(NSNull){
                        let product = Product(j: JSON(aProduct))
                        self.products.append(product)
                    }
                }
            }
        }
        
        if let anAddressObject = j["address"].object as AnyObject?{
            if !anAddressObject.isKindOfClass(NSNull){
                self.address = Address(j: JSON(anAddressObject))
            }
        }
        
        if let dateString = j["registeredAt"].string{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            if let date = formatter.dateFromString(dateString){
                self.registeredAt = date
            }
        }

    }
}