//
//  Address.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import SwiftyJSON

class Address:NSObject{

    var latitude:Double?
    var longitude:Double?
    var address:String?
    var buildingNumber:String?
    var landmark:String?
    
    init(j: JSON){
        self.latitude = j["latitude"].double
        self.longitude = j["longitude"].double
        self.address = j["address"].string
        self.buildingNumber = j["buildingNumber"].string
        self.landmark = j["landmark"].string
    }
}