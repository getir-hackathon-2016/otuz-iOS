//
//  CartViewController.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

class CartViewController:UIViewController,BarcodeScannerDelegate{
    
    var newProductButton:UIButton!
    var popUpView:ProductPopUpView? = nil
    var foundedProduct:Product? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Cart"
        self.navigationController?.navigationBar.titleTextAttributes = NavigationHelper.titleAttributes()
        
        self.newProductButton.addTarget(self, action: "openBarcodeScanner", forControlEvents: UIControlEvents.TouchUpInside)
        self.newProductButton.setTitle("ADD NEW PRODUCT", forState: UIControlState.Normal)
        
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(hexString: "ededed")
        initNewProductButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initNewProductButton(){
        self.newProductButton = UIButton(type: UIButtonType.System)
        self.view.addSubview(self.newProductButton)
        self.newProductButton.layer.cornerRadius = 2
        self.newProductButton.titleLabel?.font = UIFont(latoBoldWithSize: 14)
        self.newProductButton.backgroundColor = UIColor.otuzOrange()
        self.newProductButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.newProductButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.width.equalTo(self.view).offset(-20)
            make.top.equalTo(self.topLayoutGuide).offset(10)
            make.height.equalTo(40)
        }
    }
    
    func openBarcodeScanner(){
        let vc = BarcodeScannerViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func barcodeScanner(barcodeScannerViewController: BarcodeScannerViewController, didRecognizedBarcode barcode: String) {
        print("barcode founded \(barcode)")
        ProductAPI.getProduct(barcode) {
            (result, product) -> Void in
            
            if result.error == nil {
                self.foundedProduct = product
                self.openPopUpView(withProduct:product)
            }else{
                ErrorBanner.handleError(result.error!)
            }
            
        }
    }
    
    func openPopUpView(withProduct product:Product?){
        self.popUpView = ProductPopUpView()
        self.view.addSubview(self.popUpView!)
        self.popUpView!.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self.view)
        }
        
        if let urlString = product?.photoUrl{
            if let url = NSURL(string: urlString){
                self.popUpView!.productImageView.setImageWithURL(url)
            }
        }
        
        self.popUpView!.cancelButton.addTarget(self, action: "popUpDidDismiss", forControlEvents: UIControlEvents.TouchUpInside)
        self.popUpView!.confirmButton.addTarget(self, action: "popUpDidConfirm", forControlEvents: .TouchUpInside)
    }
    
    func popUpDidDismiss(){
        dismissPopUpView()
    }
    
    func popUpDidConfirm(){
        print("productDidConfirm")
        print(self.foundedProduct)
        dismissPopUpView()
    }
    
    func dismissPopUpView(){
        if let popUp = self.popUpView{
            if popUp.superview != nil {
                popUp.removeFromSuperview()
                self.popUpView = nil
                self.foundedProduct = nil
            }
        }
    }
    
}