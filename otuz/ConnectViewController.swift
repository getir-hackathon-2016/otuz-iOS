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
import FBSDKLoginKit

class ConnectViewController:UIViewController,UIScrollViewDelegate{

    var facebookButton:UIButton!
    var logoImageView:UIImageView!
    var pageControl:UIPageControl!
    var scrollView:UIScrollView!
    var walkthroughViews:[WalkthroughView] = []
    
    struct WalkthroughData{
        var titleText:String!
        var descriptionText:String!
    }
    
    var data:[WalkthroughData] = [
    WalkthroughData(titleText: "otuz", descriptionText: "düzenli olarak aldığınız şeyleri öğrenir, her ay kapınıza getirir"),
    WalkthroughData(titleText: "lokasyon", descriptionText: "daha hızlı ve basit ulaşabilmek için konumunuzu kullanır"),
    WalkthroughData(titleText: "bildirim", descriptionText: "bilgilendirir, siparişiniz yola çıkmadan önce onay alır")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.otuzGreen()
        self.facebookButton.addTarget(self, action: "facebookButtonClicked", forControlEvents: .TouchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if walkthroughViews.count == 0{
            self.addWalkthroughViews()
        }
        
    }
    
    override func loadView() {
        super.loadView()
        initFacebookButton()
        initLogoImageView()
        initScrollView()
        initPageControl()
        addConstraints()
    }
    
    func initFacebookButton(){
        self.facebookButton = UIButton(type: .System)
        self.view.addSubview(facebookButton)
        self.facebookButton.backgroundColor = UIColor.whiteColor()
        self.facebookButton.titleLabel?.font = UIFont(latoBoldWithSize: 16)
        self.facebookButton.setTitle("Connect with Facebook", forState: UIControlState.Normal)
        self.facebookButton.setTitleColor(UIColor(hexString: "3b5998"), forState: UIControlState.Normal)
        
        if let facebookImage = UIImage(named: "facebook"){
            let originalFacebookImage = facebookImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            self.facebookButton.setImage(originalFacebookImage, forState: UIControlState.Normal)
            self.facebookButton.contentEdgeInsets = UIEdgeInsetsMake(0,4,0,4)
            self.facebookButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 30)
        }
        
    }
    
    func initLogoImageView(){
        self.logoImageView = UIImageView()
        self.view.addSubview(self.logoImageView)
        self.logoImageView.image = UIImage(named: "logo")
    }
    
    func initScrollView(){
        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
    }
    
    func initPageControl(){
        
        self.pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
        pageControl.numberOfPages = data.count
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "3b5998")
        self.view.addSubview(self.pageControl)
        
    }
    
    func addConstraints(){
        
        self.facebookButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view).offset(50)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        self.logoImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.topLayoutGuide).offset(40)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.top.equalTo(self.logoImageView.snp_bottom)
            make.bottom.equalTo(self.pageControl.snp_top).offset(-10)
        }
        
        self.pageControl.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view).offset(-70)
            make.width.equalTo(self.view)
            make.height.equalTo(10)
        }
    }
    
    func showFacebookButton(){
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.3) { () -> Void in
            self.facebookButton.snp_updateConstraints { (make) -> Void in
                make.bottom.equalTo(self.view)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func addWalkthroughViews(){
        for var i=0; i<data.count; i++ {
            
            var aViewFrame = CGRectMake(0,0,self.scrollView.width,self.scrollView.height)
            if i != 0 {
                let leftView = self.walkthroughViews[i-1]
                aViewFrame.origin.x = leftView.right
            }
            
            let walkthroughData = self.data[i]
            
            let aView = WalkthroughView(frame: aViewFrame)
            aView.titleLabel.text = walkthroughData.titleText
            aView.descriptionLabel.text = walkthroughData.descriptionText
            aView.descriptionLabel.sizeToFit()
            aView.centerDescriptionLabel()
            self.scrollView.addSubview(aView)
            self.walkthroughViews.append(aView)
            
        }
        
        self.scrollView.contentSize.width = CGFloat(self.data.count) * self.scrollView.width
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageDidChange(Int(page))
    }
    
    func pageDidChange(page:Int){
        self.pageControl?.currentPage = page
        
        if page == 1{
            NSNotificationCenter.defaultCenter().postNotificationName(AskPermissionForLocation, object: nil)
        }
        
        if page == 2{
            NSNotificationCenter.defaultCenter().postNotificationName(AskPermissionForPushNotification, object: nil)
            showFacebookButton()
        }
        
    }
    
    func facebookButtonClicked(){

        FBSDKLoginManager().logInWithReadPermissions([], fromViewController: nil, handler: { (result, error) -> Void in
            
            if(error != nil){
                ErrorBanner.unknownErrorBanner().show()
                return
            }else if result.isCancelled{
                Banner(title: "Giriş yapabilmek için lütfen onaylayın", didTapBlock: nil).show()
                return
            } else{
                if FBSDKAccessToken.currentAccessToken() != nil {
                    if let userId = FBSDKAccessToken.currentAccessToken().userID{
                        if let tokenString = FBSDKAccessToken.currentAccessToken().tokenString{
                            self.requestFacebookData()
                            return
                        }
                    }
                }
                
                ErrorBanner.unknownErrorBanner().show()
                
            }
            
        })
    }
    
    func requestFacebookData(){
        FacebookConnect.dataRequest { (data, error) -> Void in
            if !error {
                self.facebookConnectCall(data)
            }else{
                ErrorBanner.unknownErrorBanner()
            }
        }
    }
    
    func facebookConnectCall(user:FacebookUser){
        let actInd = ActivityIndicator.start(self.view)
        
        UserAPI.facebookConnect(user, completion: {
            (result,user) -> Void in
            if result.error == nil{
                User.currentUser = user
                self.skipViewController()
            }else{
                ErrorBanner.handleError(result.error!)
            }
            ActivityIndicator.stop(actInd)
        })
    }
    
    func skipViewController(){
        print("skipViewController")
        let cartViewController = CartViewController()
        let nc = UINavigationController(rootViewController: cartViewController)
        self.presentViewController(nc, animated: true, completion: nil)
    }
    
}