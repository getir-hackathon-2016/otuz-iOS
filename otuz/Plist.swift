//
//  Plist.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation

class Plist{
    
    static let sharedInstance = Plist()
    
    var facebookUserId:String {
        set(value){
            self.set("facebookUserId", value: value)
        }
        get{
            return self.get("facebookUserId")
        }
    }
    
    var latitude:Double? {
        set(value){
            if let lat = value{
                self.set("latitude", value: "\(lat)")
            }
        }
        get{
            return Double(self.get("latitude"))
        }
    }
    
    var longitude:Double? {
        set(value){
            if let lon = value{
                self.set("longitude", value: "\(lon)")
            }
        }
        get{
            return Double(self.get("longitude"))
        }
    }
    
    func get(key:NSString) -> String {
        var myDict: NSDictionary?
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("Data.plist")
        
        myDict = NSDictionary(contentsOfFile: path)
        
        if let dict = myDict {
            if(dict.objectForKey(key) != nil) {
                return "\(dict.objectForKey(key)!)"
            } else {
                return ""
            }
        }
        
        return ""
    }
    
    func set(key:NSString, value:String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("Data.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        if(!fileManager.fileExistsAtPath(path))
        {
            let bundle = NSBundle.mainBundle().pathForResource("Data", ofType: "plist")
            do {
                try fileManager.copyItemAtPath(bundle!, toPath: path)
            } catch _ {
            }
        }
        
        let dict = NSMutableDictionary(contentsOfFile: path)!
        
        dict.setValue(value, forKey: key as String)
        dict.writeToFile(path, atomically: false)
        
    }

}