//
//  WalkthroughView.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughView:UIView {
    
    var titleLabel:UILabel!
    var descriptionLabel:UILabel!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(){
        initDescriptionLabel()
        initTitleLabel()
    }
    
    func initTitleLabel(){
        let titleLabelHeight:CGFloat = 25
        self.titleLabel = UILabel()
        self.titleLabel.frame = CGRectMake(0,self.descriptionLabel.top - titleLabelHeight - 30,self.width,titleLabelHeight)
        self.titleLabel.textAlignment = .Center
        self.titleLabel.font = UIFont(latoBoldWithSize: 20)
        self.titleLabel.textColor = UIColor(hexString: "3b5998")
        self.addSubview(titleLabel)
    }
    
    func initDescriptionLabel(){
        self.descriptionLabel = UILabel()
        self.descriptionLabel.frame = CGRectMake(20,self.centerY,self.width-40,50)
        self.descriptionLabel.textAlignment = .Center
        self.descriptionLabel.font = UIFont(latoRegularWithSize: 15)
        self.descriptionLabel.textColor = UIColor.whiteColor()
        self.descriptionLabel.numberOfLines = 0
        self.addSubview(descriptionLabel)
    }

    func centerDescriptionLabel(){
        descriptionLabel.frame.origin.x = (self.width - descriptionLabel.width)/2
    }

    
}