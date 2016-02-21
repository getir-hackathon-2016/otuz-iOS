//
//  BarcodeScannerViewController.swift
//  otuz
//
//  Created by Emre Berk on 20/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import Foundation
import MTBBarcodeScanner

protocol BarcodeScannerDelegate{
    func barcodeScanner(barcodeScannerViewController:BarcodeScannerViewController,didRecognizedBarcode barcode:String)
}

class BarcodeScannerViewController:UIViewController {
    
    var scanner:MTBBarcodeScanner?
    var delegate:BarcodeScannerDelegate?
    
    var barcodeView:UIView!
    var scanningLabel:UILabel!
    var dismissButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scanningLabel.text = "Taranıyor"
        self.dismissButton.setTitle("İptal", forState: UIControlState.Normal)
        self.dismissButton.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        
        initBarcodeView()
        initScanningLabel()
        initDismissButton()
        self.view.backgroundColor = UIColor(hexString: "ededed")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.scanner == nil {
            initScanner()
            initScanAnimation()
        }
        
    }
    
    func initBarcodeView(){
        self.barcodeView = UIView()
        self.view.addSubview(barcodeView)
        
        self.barcodeView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.height.equalTo(200)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
    }
    
    func initScanningLabel(){
        self.scanningLabel = UILabel()
        self.view.addSubview(self.scanningLabel)
        self.scanningLabel.font = UIFont(latoBoldWithSize: 20)
        self.scanningLabel.textColor = UIColor.otuzOrange()
        self.scanningLabel.textAlignment = .Center
        
        self.scanningLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.topLayoutGuide).offset(60)
            make.width.equalTo(self.view)
            make.height.equalTo(25)
        }
    }
    
    func initDismissButton(){
        self.dismissButton = UIButton(type: UIButtonType.System)
        self.view.addSubview(self.dismissButton)
        self.dismissButton.layer.cornerRadius = 2
        self.dismissButton.titleLabel?.font = UIFont(latoBoldWithSize: 16)
        self.dismissButton.backgroundColor = UIColor.otuzDarkGreen()
        self.dismissButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.dismissButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.width.equalTo(self.view).offset(-40)
            make.bottom.equalTo(self.bottomLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func initScanner(){
        self.scanner = MTBBarcodeScanner(previewView: self.barcodeView)
        
        MTBBarcodeScanner.requestCameraPermissionWithSuccess { (success) -> Void in
            if success {
                print("camera permission success")
                self.startScanning()
            } else{
                Banner(title: "We need your camera permission to scan barcodes.", didTapBlock: nil).show()
            }
        }
    }
    
    func initScanAnimation(){
        let label = UILabel()
        label.backgroundColor = UIColor.redColor()
        self.view.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.barcodeView)
            make.top.equalTo(self.barcodeView).offset(-5)
            make.bottom.equalTo(self.barcodeView).offset(5)
            make.width.equalTo(2)
        }
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.6, delay: 0, options: [.Autoreverse,.Repeat], animations: { () -> Void in
            
            label.snp_remakeConstraints { (make) -> Void in
                make.left.equalTo(self.barcodeView.snp_right)
                make.top.equalTo(self.barcodeView).offset(-5)
                make.bottom.equalTo(self.barcodeView).offset(5)
                make.width.equalTo(2)
            }
            
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }

    func startScanning(){
        self.scanner!.startScanningWithResultBlock { (codes) -> Void in

            self.scanner!.freezeCapture()

            for code in codes {
                if let barcodeString = code.stringValue{
                    self.delegate?.barcodeScanner(self, didRecognizedBarcode: barcodeString)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    break;
                }
            }
            
        }
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}