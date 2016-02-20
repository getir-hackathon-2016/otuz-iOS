//
//  APIError.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIError: NSObject {
    var code:Int?
    var message:String?
    
    init(j:JSON){
        self.code = j["code"].int
        self.message = j["message"].string
    }
    
    override init(){
        super.init()
    }
    
}
