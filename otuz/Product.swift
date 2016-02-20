//
//  Product.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import SwiftyJSON

class Product{
    
    var id:String?
    var name:String?
    var photoUrl:String?
    var barcodeNumber:String?
    var price:Double?
    var quantity:Int?
    
    init(j: JSON){
        self.id = j["_id"].string
        self.name = j["name"].string
        self.photoUrl = j["photoUrl"].string
        self.barcodeNumber = j["barcodeNumber"].string
        self.price = j["price"].double
        self.quantity = j["quantity"].int
    }
    

}