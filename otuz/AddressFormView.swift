//
//  AddressFormView.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

class AddressFormView:UIView{

    var addressTextField:FormTextField!
    var doorNumberTextField:FormTextField!
    var buildingNumberTextField:FormTextField!
    var landmarkTextField:FormTextField!
    var doneButton:UIButton!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(){
        initAddressTextField()
        initDoorNumberTextField()
        initBuildingNumberTextField()
        initLandmarkTextField()
        initDoneButton()
    }
    
    func initAddressTextField(){
        addressTextField = FormTextField()
        addressTextField.placeholder = "ADDRESS".localized
        self.addSubview(addressTextField)
        addressTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.width.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(40)
        }
    }
    
    func initDoorNumberTextField(){
        doorNumberTextField = FormTextField()
        doorNumberTextField.placeholder = "DOOR_NO".localized
        self.addSubview(doorNumberTextField)
        doorNumberTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(addressTextField)
            make.width.equalTo(addressTextField).offset(-5).multipliedBy(0.5)
            make.height.equalTo(addressTextField)
            make.top.equalTo(addressTextField.snp_bottom).offset(10)
        }
    }
    
    func initBuildingNumberTextField(){
        buildingNumberTextField = FormTextField()
        buildingNumberTextField.placeholder = "BUILDING_NO".localized
        self.addSubview(buildingNumberTextField)
        buildingNumberTextField.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(addressTextField)
            make.width.equalTo(doorNumberTextField)
            make.height.equalTo(doorNumberTextField)
            make.top.equalTo(doorNumberTextField)
        }
    }
    
    func initLandmarkTextField(){
        landmarkTextField = FormTextField()
        landmarkTextField.placeholder = "LANDMARK".localized
        self.addSubview(landmarkTextField)
        landmarkTextField.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(addressTextField)
            make.width.equalTo(addressTextField)
            make.height.equalTo(addressTextField)
            make.top.equalTo(buildingNumberTextField.snp_bottom).offset(10)
        }
    }
    
    func initDoneButton(){
        doneButton = UIButton(type: UIButtonType.System)
        doneButton.setTitle("SAVE".localized, forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addSubview(doneButton)
        doneButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(landmarkTextField.snp_bottom).offset(10)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self).offset(-20)
            make.height.equalTo(40)
            doneButton.titleLabel?.font = UIFont(latoBoldWithSize: 14)
            doneButton.backgroundColor = UIColor.otuzGreen()
        }


    }

}