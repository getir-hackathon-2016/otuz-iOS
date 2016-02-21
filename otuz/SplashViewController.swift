//
//  ViewController.swift
//  otuz
//
//  Created by Emre Berk on 19/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func getData(){
        
        UserAPI.getUser(Plist.sharedInstance.facebookUserId) {
            (result, user) -> Void in
            
            if result.error == nil {
                if user != nil {
                    User.currentUser = user
                    let nc = UINavigationController(rootViewController: CartViewController())
                    self.presentViewController(nc, animated: true, completion: nil)
                    return;
                }
            }
            
            self.openConnectViewController()
            
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Plist.sharedInstance.facebookUserId == "" {
            openConnectViewController()
        }else{
            self.getData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override func loadView() {
        super.loadView()
        print("loadView")
        self.view.backgroundColor = UIColor.otuzGreen()
        initLogoImageView()
    }
    
    func initLogoImageView(){
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(logoImageView)
        
        logoImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.height.equalTo(100)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openConnectViewController(){
        self.presentViewController(ConnectViewController(), animated: true, completion: nil)
    }


}

