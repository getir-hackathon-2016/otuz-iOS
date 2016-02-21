//
//  FormTextField.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit

class FormTextField: UITextField {
    
    private var yMargin:CGFloat = 0
    private var xMargin:CGFloat = 10
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds,xMargin,yMargin)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds,xMargin,yMargin)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(){
        super.init(frame: CGRectZero)
        commonInit()
    }
    
    func commonInit(){
        style()
    }
    
    func style(){
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor(hexString: "efefef").CGColor
        self.layer.borderWidth = 1
        self.textColor = UIColor(hexString: "363636")
        self.font = UIFont(latoLightWithSize: 14)
        self.textAlignment = .Left
    }
}
