//
//  ProductPopUpView.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

class ProductPopUpView:UIView {
    
    private var centerView:UIView!
    private var blurEffectStyle: UIBlurEffectStyle = .Dark
    private var blurEffect: UIBlurEffect!
    private var blurView: UIVisualEffectView!
    private var vibrancyView: UIVisualEffectView!
    
    var productImageView:UIImageView!
    
    private var descriptionView:UIView!
    
    var nameLabel:UILabel!
    var priceLabel:UILabel!

    var confirmButton:UIButton!
    var cancelButton:UIButton!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// TODO: add subviews constraints
    func commonInit(){
        initBlurView()
        initCenterView()
        initProductImageView()
        initConfirmButton()
        initCancelButton()
        initPriceLabel()
        initNameLabel()
        initConstraints()
        self.cancelButton.titleLabel?.font = UIFont(latoBoldWithSize: 15)
        self.cancelButton.setTitle("İptal", forState: UIControlState.Normal)
        self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.confirmButton.titleLabel?.font = UIFont(latoBoldWithSize: 15)
        self.confirmButton.setTitle("Sepete Ekle", forState: UIControlState.Normal)
        self.confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        blurView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self)
        }
        vibrancyView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self)
        }
    }
    
    func initBlurView(){
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurView)
        
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        addSubview(vibrancyView)
        
        blurView.contentView.addSubview(vibrancyView)
    }
    
    func initCenterView(){
        
        self.centerView = UIView()
        self.addSubview(centerView)
        self.centerView.layer.cornerRadius = 2
        centerView.backgroundColor = UIColor.otuzOrange()
        
    }
    
    func initProductImageView(){
        self.productImageView = UIImageView()
        self.productImageView.contentMode = .ScaleAspectFill
        self.addSubview(self.productImageView)
    }
    
    
    func initNameLabel(){
        self.nameLabel = UILabel()
        self.nameLabel.textAlignment = .Center
        self.nameLabel.font = UIFont(latoBoldWithSize: 20)
        self.nameLabel.textColor = UIColor(hexString: "3b5998")
        self.addSubview(nameLabel)
    }
    
    func initConfirmButton(){
        self.confirmButton = UIButton(type: UIButtonType.System)
        self.addSubview(confirmButton)
    }
    
    func initCancelButton(){
        self.cancelButton = UIButton(type: UIButtonType.System)
        self.addSubview(cancelButton)
    }
    
    func initPriceLabel(){
        self.priceLabel = UILabel()
        self.priceLabel.textAlignment = .Center
        self.priceLabel.font = UIFont(latoRegularWithSize: 15)
        self.priceLabel.textColor = UIColor.whiteColor()
        self.priceLabel.numberOfLines = 0
        self.addSubview(priceLabel)
    }
    
    func initConstraints(){
        
        centerView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(self.snp_width).offset(40)
        }
        
        productImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.centerView)
            make.left.right.equalTo(self.centerView)
            make.height.equalTo(productImageView.snp_width)
        }
        
        self.confirmButton.snp_makeConstraints {
            (make) -> Void in
            make.bottom.equalTo(self.centerView).offset(-10)
            make.right.equalTo(self.centerView)
            make.height.equalTo(30)
            make.width.equalTo(self.centerView).multipliedBy(0.5)
        }
        
        self.cancelButton.snp_makeConstraints {
            (make) -> Void in
            make.bottom.equalTo(self.centerView).offset(-10)
            make.left.equalTo(self.centerView)
            make.height.equalTo(self.confirmButton)
            make.width.equalTo(self.confirmButton)
        }
    }

}