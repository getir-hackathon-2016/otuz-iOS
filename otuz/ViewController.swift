//
//  ViewController.swift
//  otuz
//
//  Created by Emre Berk on 19/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import UIKit
import MTBBarcodeScanner

class ViewController: UIViewController {

    var scanner:MTBBarcodeScanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.scanner = MTBBarcodeScanner(previewView: self.view)
//        
//        MTBBarcodeScanner.requestCameraPermissionWithSuccess { (success) -> Void in
//            if success {
//                print("camera permission success")
//                self.startScanning()
//            } else{
//                print("camera permission fail")
//            }
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startScanning(){
        self.scanner.startScanningWithResultBlock { (codes) -> Void in
            
            for code in codes {
                print(code)
            }
            self.scanner.freezeCapture()
            self.scanner.stopScanning()
        }
    }


}

