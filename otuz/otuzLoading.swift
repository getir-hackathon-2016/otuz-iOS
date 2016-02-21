//
//  otuzLoading.swift
//  otuz
//
//  Created by Emre Berk on 21/02/16.
//  Copyright © 2016 Emre Berk. All rights reserved.
//

import UIKit

public class otuzLoading: UIView {
    
    private var countLabel:UILabel!
    public static var animating:Bool = false
    
    public class var sharedInstance: otuzLoading {
        struct Singleton {
            static let instance = otuzLoading(frame: CGRect.zero)
        }
        return Singleton.instance
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        blurEffect = UIBlurEffect(style: blurEffectStyle)
        blurView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurView)
        
        vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        addSubview(vibrancyView)
        
        blurView.contentView.addSubview(vibrancyView)
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public class func show(animated: Bool = true) {
        
        
        if let window = UIApplication.sharedApplication().keyWindow{
            
            let spinner = otuzLoading.sharedInstance
            
            spinner.updateFrame()
            spinner.initCountLabel()
            
            if spinner.superview == nil {
                //show the spinner
                spinner.alpha = 0.0
                otuzLoading.animating = true
                window.addSubview(spinner)
                
                UIView.animateWithDuration(0.33, delay: 0.0, options: .CurveEaseOut, animations: {
                    spinner.alpha = 1.0
                    }, completion: nil)
            }
            
        }
        
    }
    
    public class func hide() {
        let spinner = otuzLoading.sharedInstance
        
        if  spinner.superview == nil {
            return
        }
        
        if (spinner.countLabel != nil && spinner.countLabel.superview != nil){
            spinner.countLabel.removeFromSuperview()
        }
        
        if spinner.timer != nil {
            spinner.timer!.invalidate()
            spinner.timer = nil
        }
        
        
        otuzLoading.animating = false
        spinner.alpha = 1.0
        spinner.removeFromSuperview()
        
    }
    
    public override var frame: CGRect {
        didSet {
            if frame == CGRect.zero {
                return
            }
            blurView.frame = bounds
            vibrancyView.frame = blurView.bounds
        }
    }
    
    
    // MARK: - Private interface
    
    //
    // layout elements
    //
    
    private var blurEffectStyle: UIBlurEffectStyle = .Dark
    private var blurEffect: UIBlurEffect!
    private var blurView: UIVisualEffectView!
    private var vibrancyView: UIVisualEffectView!
    
    
    private func updateFrame() {
        
        if let window = UIApplication.sharedApplication().keyWindow{
            otuzLoading.sharedInstance.frame = window.frame
        }
    }
    
    private var timer:NSTimer?
    
    private func initCountLabel(){

        self.countLabel = UILabel(frame: self.frame)
        self.countLabel.font = UIFont(latoBoldWithSize: 80)
        self.countLabel.textColor = UIColor.otuzGreen()
        self.countLabel.text = "30"
        self.countLabel.textAlignment = .Center
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "updateCountLabel", userInfo: nil, repeats: true)
        
        self.addSubview(self.countLabel)
    }
    
    func updateCountLabel(){
        if let text = self.countLabel.text{
            if let count = Int(text){
                let newCount = count-1
                print(newCount)
                self.countLabel.text = "\(newCount)"
            }
        }
    }
    
    // MARK: - Util methods
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
}
