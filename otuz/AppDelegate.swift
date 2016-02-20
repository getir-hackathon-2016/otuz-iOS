//
//  AppDelegate.swift
//  otuz
//
//  Created by Emre Berk on 19/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    
    // Location
    var locationManager: CLLocationManager!
    var locationStatus : NSString = "Not Started"
    var locationFixAchieved : Bool = false
    //

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        print("Plist.sharedInstance.hasWalktroughSeen \(Plist.sharedInstance.hasWalktroughSeen)")
        Plist.sharedInstance.hasWalktroughSeen = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationPermission", name: AskPermissionForPushNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationPermission", name: AskPermissionForPushNotification, object: nil)
                
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        self.window?.rootViewController = ConnectViewController()
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        UIApplication.sharedApplication().applicationIconBadgeNumber=0;

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func notificationPermission(){
        let notificationType:UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func locationPermission(){
        print("notificationPermission")
        initLocationManager()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let pushId = "\(deviceToken)"
        var trimmedPushId = ""
        
        for character in pushId.characters{
            if character != " " && character != "<" && character != ">" {
                trimmedPushId = trimmedPushId + "\(character)"
            }
        }
        print("push token: \(trimmedPushId)")
//        Plist.sharedInstance.pushToken = trimmedPushId
    }
    
    //Location Manager
    func initLocationManager() {
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if CLLocationManager.authorizationStatus() == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //Location Manager Delegate stuff
    //If failed
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("locationManager->didFailWithError")
        locationManager.stopUpdatingLocation()
        print(error, terminator: "")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager->didUpdateLocations")
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
//            Plist.sharedInstance.latitude = "\(coord.latitude)"
//            Plist.sharedInstance.longitude = "\(coord.longitude)"
            print("latitude: \(coord.latitude), longitude: \(coord.longitude)")
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    //authorization status
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        
        print(locationStatus)
        
        if (shouldIAllow == true) {
            locationManager.startUpdatingLocation()
        }
        
    }


}

