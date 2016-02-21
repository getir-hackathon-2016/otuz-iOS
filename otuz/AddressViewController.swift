//
//  AddressViewController.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import MapKit
import AddressBookUI

class AddressViewController:UIViewController,MKMapViewDelegate{
    
    var mapView: MKMapView!
    var theSpan: MKCoordinateSpan!
    var userCoor:CLLocationCoordinate2D!
    
    var geoCoder:CLGeocoder!
    
    var locationFounded = false
    
    var addressLabel: LabelInset!
    var addressFormView:AddressFormView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.title = "Adres"
        self.navigationController?.navigationBar.titleTextAttributes = NavigationHelper.titleAttributes()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        initAddressLabel()
        initMapView()
        initPin()
        configureMapView()

    }
    
    func configureMapView(){
        let latDelta = 0.03 as CLLocationDegrees
        let longDelta = 0.03 as CLLocationDegrees
        self.theSpan = MKCoordinateSpanMake(latDelta, longDelta) as MKCoordinateSpan
        self.mapView.delegate = self
        mapView.rotateEnabled = false
        
        self.geoCoder = CLGeocoder()
        self.userCoor = CLLocationCoordinate2D()
        //self.addAnnotation()
        
        centerToUserLocation()
        
        var theRegion = MKCoordinateRegionMake(userCoor, theSpan)
        self.mapView.setRegion(theRegion, animated: true)
        getAddressForLocation()
    }
    
    func initMapView(){
        self.mapView = MKMapView()
        self.view.addSubview(self.mapView)
        self.mapView.snp_makeConstraints {
            (make) -> Void in
            make.top.equalTo(self.view)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.addressLabel.snp_top)
        }
        
    }
    
    func initPin(){
        let imageView = UIImageView(image: UIImage(named: "pin"))
        self.mapView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.mapView)
            make.width.height.equalTo(48)
            make.bottom.equalTo(self.mapView.snp_centerY)
        }
    }
    
    func initAddressLabel(){
        self.addressLabel = LabelInset()
        self.addressLabel.numberOfLines = 0
        self.addressLabel.font = UIFont(latoRegularWithSize: 14)
        self.addressLabel.backgroundColor = UIColor.whiteColor()
        self.addressLabel.textAlignment = .Center
        self.addressLabel.userInteractionEnabled = true
        self.addressLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addressLabelClicked"))
        self.view.addSubview(self.addressLabel)
        self.addressLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.bottomLayoutGuide)
            make.width.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    
    
    func addressLabelClicked(){
        print("addressLabelClicked")
        
        self.addressFormView = AddressFormView()
        self.addressFormView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.addressFormView!)
        
        fillAddressData()
        self.addressFormView?.doneButton.addTarget(self, action: "addressDoneClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.userInteractionEnabled = false
        
        self.addressLabel.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(self.bottomLayoutGuide)
        }
        
        self.addressFormView!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.bottomLayoutGuide)
            make.width.equalTo(self.view)
        }
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5) { () -> Void in
            
            self.mapView.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(self.view)
                make.width.equalTo(self.view)
                make.bottom.equalTo(self.addressFormView!.snp_top)
            }
            
            self.addressFormView!.snp_remakeConstraints { (make) -> Void in
                make.bottom.equalTo(self.bottomLayoutGuide)
                make.width.equalTo(self.view)
                make.height.equalTo(210)
            }
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    func fillAddressData(){
        if let addressView = self.addressFormView{
            if let user = User.currentUser{
                if let address = user.address{
                    addressView.doorNumberTextField.text = address.doorNumber
                    addressView.buildingNumberTextField.text = address.buildingNumber
                    addressView.landmarkTextField.text = address.landmark
                    addressView.addressTextField.text = address.address
                }else{
                    addressView.addressTextField.text = addressLabel.text
                }
            }
        }
    }
    
    func addressDoneClicked(){
        if let addressView = self.addressFormView{
            let doorNo = addressView.doorNumberTextField.text
            let buildingNo = addressView.buildingNumberTextField.text
            let landmark = addressView.landmarkTextField.text
            let address = addressView.addressTextField.text
            
            if doorNo == "" || buildingNo == "" || landmark == "" || address == "" {
                ErrorBanner.standartBanner().show()
                return;
            }else{
                let address = Address()
                address.buildingNumber = buildingNo
                address.doorNumber = doorNo
                address.landmark = landmark
                address.address = landmark
                address.latitude = self.mapView.centerCoordinate.latitude
                address.longitude = self.mapView.centerCoordinate.longitude
                updateAddress(address)
            }
        }
    }
    
    func updateAddress(address:Address){
        UserAPI.updateAddress(address, facebookId: Plist.sharedInstance.facebookUserId) {
            (result, user) -> Void in
            
            if result.error == nil {
                User.currentUser = user
                self.dismissViewControllerAnimated(true, completion: nil)
            }else{
                ErrorBanner.handleError(result.error!)
            }
            
        }
    }
    
    func centerToUserLocation(){
        
        if let lat = Plist.sharedInstance.latitude{
            userCoor.latitude = lat
        }
        
        if let lon = Plist.sharedInstance.longitude{
            userCoor.longitude = lon
        }
        
        print(userCoor)
        
        self.mapView.setCenterCoordinate(userCoor, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.getAddressForLocation()
        
    }
    
    func getAddressForLocation(){
        let center = self.mapView.centerCoordinate
        let centerLoc = CLLocation(latitude: center.latitude, longitude: center.longitude)
        geoCoder.reverseGeocodeLocation(centerLoc) {
            (placemarks, error) -> Void in
            if placemarks != nil {
                if placemarks!.count > 0 {
                    if self.locationFounded == false{
                        self.locationFounded = true
                        self.getAddressForLocation()
                    }else{
                        let aPlaceMark:CLPlacemark = placemarks![0]
                        self.parsePlaceMark(aPlaceMark,type: "withLocation")
                    }
                }
            }else{
                print("no result on search")
            }
        }
    }
    
    func parsePlaceMark(aPlaceMark:CLPlacemark, type:String){
        if let addressDic = aPlaceMark.addressDictionary{
            if let formattedAddressLines = addressDic["FormattedAddressLines"] as! [String]?{
                
                if let loc = aPlaceMark.location {
                    if type == "withString"{
                        self.mapView.setCenterCoordinate(loc.coordinate, animated: true)
                    }
                }
                
                var allString = ""
                
                for aString:String in formattedAddressLines {
                    allString.appendContentsOf(aString + " ")
                }
                
                
                self.addressLabel.text = allString
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let i = notification.userInfo!
        
        let keyboardSize = (notification.userInfo! as NSDictionary).objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size
        
        let duration = i[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: {
            
            self.addressFormView?.snp_remakeConstraints(closure: { (make) -> Void in
                make.bottom.equalTo(self.bottomLayoutGuide).offset(-keyboardSize!.height)
                make.width.equalTo(self.view)
                make.height.equalTo(220)
            })
            
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let i = notification.userInfo!
        
        let duration = i[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(duration, delay: 0, options: .BeginFromCurrentState, animations: {
            
            
            self.addressFormView?.snp_remakeConstraints(closure: { (make) -> Void in
                make.bottom.equalTo(self.bottomLayoutGuide)
                make.width.equalTo(self.view)
                make.height.equalTo(220)
            })
            
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

}