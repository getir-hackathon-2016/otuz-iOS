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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Cart"
        self.navigationController?.navigationBar.titleTextAttributes = NavigationHelper.titleAttributes()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "mapClicked")
        
        self.newProductButton.addTarget(self, action: "openBarcodeScanner", forControlEvents: UIControlEvents.TouchUpInside)
        self.newProductButton.setTitle("ADD NEW PRODUCT", forState: UIControlState.Normal)
        
        tableView.registerNib(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.getProductsFromUser()

    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(hexString: "ededed")
        initNewProductButton()
        initTableView()
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
            make.bottom.equalTo(self.bottomLayoutGuide)
        }
    }
    
    func mapClicked(){
        let vc = AddressViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true, completion: nil)
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
        UserAPI.saveProduct(Plist.sharedInstance.facebookUserId, productId: self.foundedProduct!.id!) {
            (result, user) -> Void in
            
            if result.error == nil {
                User.currentUser = user
                self.getProductsFromUser()
            }else{
                ErrorBanner.handleError(result.error!)
            }
            
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
            }else{
                ErrorBanner.handleError(result.error!)
            }
            
            otuzLoading.hide()
        }
        
    }
    
    
}