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
    
    var tableView:UITableView!
    var products:[Product] = []
    
    var bottomView:UIView!
    var dateButton:UIButton!
    var buyButton:UIButton!

    var datePickerView:UIView?
    var datePicker:UIDatePicker?
    
    var selectedDate:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sepet"
        self.navigationController?.navigationBar.titleTextAttributes = NavigationHelper.titleAttributes()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "location"), style: .Plain, target: self, action: "mapClicked")
        
        self.newProductButton.addTarget(self, action: "openBarcodeScanner", forControlEvents: UIControlEvents.TouchUpInside)
        self.newProductButton.setTitle("Yeni Ürün Ekle", forState: UIControlState.Normal)
        
        tableView.registerNib(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.getProductsFromUser()
        
        self.buyButton.setTitle("HEMEN AL", forState: UIControlState.Normal)
        self.buyButton.addTarget(self, action: "buyButtonClicked", forControlEvents: .TouchUpInside)
        selectedDate = NSDate()
        updateDateButton(withDate: selectedDate!)
        self.dateButton.addTarget(self, action: "dateButtonClicked", forControlEvents: .TouchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(hexString: "ededed")
        initNewProductButton()
        initBottomView()
        initTableView()
        initDateButton()
        initBuyButton()
        bottomViewConstraints()
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
    
    func initBottomView(){
        self.bottomView = UIView()
        self.bottomView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.bottomView)
        
        self.bottomView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.bottomLayoutGuide)
            make.width.equalTo(self.view)
            make.height.equalTo(70)
        }
    }
    
    func initTableView(){
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        self.tableView.allowsSelection = false
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.newProductButton.snp_bottom).offset(10)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomView.snp_top)
        }
    }
    
    func initDateButton(){
        self.dateButton = UIButton(type: .System)
        self.bottomView.addSubview(self.dateButton)
        self.dateButton.setTitleColor(UIColor.otuzGreen(), forState: .Normal)
        self.dateButton.titleLabel?.font = UIFont(latoRegularWithSize: 14)
    }
    
    func initBuyButton(){
        self.buyButton = UIButton(type: .System)
        self.bottomView.addSubview(self.buyButton)
        self.buyButton.layer.cornerRadius = 2
        self.buyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.buyButton.titleLabel?.font = UIFont(latoBoldWithSize: 16)
        self.buyButton.backgroundColor = UIColor.otuzOrange()
    }
    
    func bottomViewConstraints(){
        dateButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(bottomView).offset(10)
            make.height.equalTo(bottomView).offset(-20)
            make.width.equalTo(self.view).multipliedBy(0.5)
            make.top.equalTo(bottomView).offset(10)
        }
        
        self.buyButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(dateButton.snp_right).offset(10)
            make.right.equalTo(bottomView).offset(-10)
            make.top.equalTo(bottomView).offset(10)
            make.bottom.equalTo(bottomView).offset(-10)
        }
        
    }
    
    func mapClicked(){
        let vc = AddressViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true, completion: nil)
    }
    
    func buyButtonClicked(){
        let alert = UIAlertController(title: nil, message: "Emin misiniz?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Evet", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
            self.makePurchase()
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func makePurchase(){
        
        otuzLoading.show()
        OrderAPI.order(Plist.sharedInstance.facebookUserId, deliveryDate: self.selectedDate!) {
            (result) -> Void in
            otuzLoading.hide()
            if result.error == nil {
                let alert = UIAlertController(title: nil, message: "Siparişinizi aldık!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                ErrorBanner.handleError(result.error!)
            }
        }
    }
    
    func dateButtonClicked(){
    
        if (self.datePickerView == nil){
            
            
            self.datePickerView = UIView()
            self.view.addSubview(datePickerView!)
            
            self.datePickerView?.snp_makeConstraints(closure: {
                (make) -> Void in
                make.bottom.equalTo(self.bottomLayoutGuide)
                make.width.equalTo(self.view)
                make.height.equalTo(200)
            })
            
            let toolBar = UIToolbar()
            let toolBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dateSelected")
            toolBarButton.tintColor = UIColor.otuzGreen()
            let flexButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            
            toolBar.items = [flexButton,toolBarButton]
            datePickerView?.addSubview(toolBar)
            print(datePickerView!.frame)
            toolBar.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.datePickerView!.snp_top)
                make.width.equalTo(self.datePickerView!)
                make.height.equalTo(44)
            })
            self.datePicker = UIDatePicker()
            datePicker!.minimumDate = NSDate()
            datePicker!.backgroundColor = UIColor.whiteColor()
            datePicker!.datePickerMode = .DateAndTime
            datePicker!.date = self.selectedDate!
            datePickerView!.addSubview(datePicker!)
            
            datePicker!.snp_makeConstraints(closure: { (make) -> Void in
                make.width.equalTo(datePickerView!)
                make.bottom.equalTo(self.datePickerView!)
                make.top.equalTo(toolBar.snp_bottom)
            })
            
        }
    }
    
    func dateSelected(){
        
        selectedDate = self.datePicker!.date
        
        updateDateButton(withDate: selectedDate!)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.datePickerView?.snp_updateConstraints(closure: { (make) -> Void in
                make.bottom.equalTo(self.bottomLayoutGuide).offset(200)
            })
            self.view.layoutIfNeeded()
            
            }) { (comp) -> Void in
                if self.datePickerView != nil {
                    if self.datePickerView!.superview != nil{
                        self.datePickerView!.removeFromSuperview()
                        self.datePickerView = nil
                    }
                }
        }
        
    }
    
    func updateDateButton(withDate date:NSDate){
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = .ShortStyle
        
        if let dateString = formatter.stringFromDate(date) as String?{
            self.dateButton.setTitle(dateString, forState: UIControlState.Normal)
        }
    }
    
    func updateTotalPrice(){
        
        var total:Double = 0
        
        for product in products{
            total += Double(product.quantity!) * product.price!
        }
        
        var totalString = ""
        
        if total%1 == 0{
            let priceInt = Int(total)
            totalString = "\(priceInt) ₺"
        }else{
            totalString = "\(total) ₺"
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: totalString, style: .Plain, target: nil, action: nil)
    }
    
    func openBarcodeScanner(){
        let vc = BarcodeScannerViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func barcodeScanner(barcodeScannerViewController: BarcodeScannerViewController, didRecognizedBarcode barcode: String) {
        print("barcode founded \(barcode)")
        otuzLoading.show()
        ProductAPI.getProduct(barcode) {
            (result, product) -> Void in
            
            if result.error == nil {
                if let founded = product{
                    self.foundedProduct = founded
                    self.openPopUpView(withProduct:founded)
                }else{
                    Banner(title: "Ürün bulunamadı", didTapBlock: nil).show()
                }
            }else{
                ErrorBanner.handleError(result.error!)
            }
            
            otuzLoading.hide()
            
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
        otuzLoading.show()
        UserAPI.saveProduct(Plist.sharedInstance.facebookUserId, productId: self.foundedProduct!.id!) {
            (result, user) -> Void in
            
            if result.error == nil {
                User.currentUser = user
                self.getProductsFromUser()
            }else{
                ErrorBanner.handleError(result.error!)
            }
            
            otuzLoading.hide()
            
        }
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
    
    func getProductsFromUser(){
        if let userProducts = User.currentUser?.products{
            self.products = userProducts
            self.tableView.reloadData()
            updateTotalPrice()
        }
        
    }

}

extension CartViewController:UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! ProductCell
        cell.centerView.layer.cornerRadius = 2
        cell.centerView.layer.masksToBounds = true
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        
        let aProduct = self.products[indexPath.row]
        if let urlString = aProduct.photoUrl{
            if let url = NSURL(string: urlString){
                cell.productImageView.setImageWithURL(url)
            }
        }
        
        cell.nameLabel.text = aProduct.name
        
        if let quantity = aProduct.quantity{
            cell.countLabel.text = "\(quantity)"
        }
        
        if let price = aProduct.price{
            if price%1 == 0{
                let priceInt = Int(price)
                cell.priceLabel.text = "\(priceInt) ₺"
            }else{
                cell.priceLabel.text = "\(price) ₺"
            }
        }else{
            cell.priceLabel.text = ""
        }
        
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: "plusClicked:", forControlEvents: .TouchUpInside)
        
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: "minusClicked:", forControlEvents: .TouchUpInside)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelect")
    }
    
    func plusClicked(sender:UIButton){
        changeProductQuantity(atIndex: sender.tag, increase: true)
    }
    
    func minusClicked(sender:UIButton){
        changeProductQuantity(atIndex: sender.tag, increase: false)
    }
    
    func changeProductQuantity(atIndex index:Int,increase:Bool){
        
        let product = self.products[index]
        
        if !increase && product.quantity == 0 {
            return
        }
        
        var quantity = product.quantity!
        
        increase ? quantity++ : quantity--
        
        otuzLoading.show()
        
        UserAPI.changeProductQuantity(Plist.sharedInstance.facebookUserId, quantity: quantity, productId: product.id!) {
            (result, user) -> Void in
            if result.error == nil {
                product.quantity = quantity
                self.tableView.reloadData()
                self.updateTotalPrice()
            }else{
                ErrorBanner.handleError(result.error!)
            }
            
            otuzLoading.hide()
        }
        
    }
    
    
}