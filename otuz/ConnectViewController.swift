//
//  ConnectViewController.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ConnectViewController:UIViewController{

    var facebookButton:UIButton!
    
    override func loadView() {
        super.loadView()
        initFacebookButton()
    }
    
    func initFacebookButton(){
        self.facebookButton = UIButton(type: .System)
        self.view.addSubview(facebookButton)
        self.facebookButton.backgroundColor = UIColor(hexString: "3b5998")
        self.facebookButton.titleLabel?.font = UIFont(latoBoldWithSize: 16)
        self.facebookButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        self.facebookButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.facebookButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    
}