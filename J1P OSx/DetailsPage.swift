//
//  HomePage.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/4/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Cocoa
import AppKit

class DetailsPage: NSViewController {
    //Linke the lables on the details page to the selected coupon
    @IBOutlet weak var detailsTableView: NSTableView!
    @IBOutlet weak var couponTitle: NSTextField!
    @IBOutlet weak var couponExpiration: NSTextField!
    @IBOutlet weak var couponDiscount: NSTextField!
    
    var selectedRow = -1
    //Sanity check for the coupon selection
    func selectedCoupon() -> CouponData? {
        selectedRow = self.detailsTableView.selectedRow;
        if selectedRow >= 0 && selectedRow < self.couponsAll.count {
            detailsTableView.reloadData()
            return self.couponsAll[selectedRow]
        }
        return nil
    }
    
    //To initialze the table by the selection, times 2 since the array was devided into half
    func selectedCoupon2() -> CouponData? {
        return self.couponsAll[AppDelegate.globalValues.homePageSelection]
    }
    
    //Initialize the Lables showing on the coupon details
    func updateDetailInfo(doc: CouponData?) {
        var couponTitle = ""
        var couponCode = ""
        var couponDiscount = 0
//        var couponTermsConditions = ""
        
        if let CouponData = doc {
            couponTitle = CouponData.couponTitle!
            couponCode = CouponData.couponExpiration!
            couponDiscount = CouponData.couponDiscount!
            AppDelegate.globalValues.toPrinter = couponTitle
        }
        
        self.couponTitle.stringValue = couponTitle
        self.couponExpiration.stringValue = couponCode
        self.couponDiscount.integerValue = Int(couponDiscount)
    }
    
    //Set an observer to reload the table after selection on the home page
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refreshMyTableView", object: nil)
    }
    func refreshList(notification: NSNotification){
        self.view.hidden = AppDelegate.globalValues.flagToHideDetails
        detailsTableView.reloadData()
    }

    //initialize data set
    var couponsAll = [CouponData]()
    
    func createCoupons() {
        
        let numberOfCoupons=6
        
        // Creating coupons and put them in two arrays for two columns
        for index in 1...numberOfCoupons {
            
            var coupon = CouponData (couponID: index, couponTitle: "Coupon\(index)", couponCode: "6/\(index)/2016", couponDiscount: 20+index, couponImage: NSImage(named:"coupon\(index)"))
            
            couponsAll.append(coupon)       
        }
    
    }
    
    //HomeButton function
    @IBAction func homeButton(sender: NSButton) {
        AppDelegate.globalValues.flagToHideHome = false
        AppDelegate.globalValues.flagToHideSearch = true
        AppDelegate.globalValues.flagToHideDetails = true
        NSNotificationCenter.defaultCenter().postNotificationName("hideHomePage", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("refreshMyTableView", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("hideMySearch", object: nil)
    }
    
    //SearchButton Function
    @IBAction func searchButton(sender: NSButton) {
        AppDelegate.globalValues.flagToHideHome = true
        AppDelegate.globalValues.flagToHideSearch = false
        AppDelegate.globalValues.flagToHideDetails = true
        NSNotificationCenter.defaultCenter().postNotificationName("hideHomePage", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("refreshMyTableView", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("hideMySearch", object: nil)
    }
    
    
    
    //Print using webservice
    @IBAction func printButton(sender: NSButton) {
    let url = NSURL(string: "http://localhost:8080/myapp/mycoupon/\(AppDelegate.globalValues.toPrinter)")
    let theRequest = NSURLRequest(URL: url!)
    
    NSURLConnection.sendAsynchronousRequest(theRequest, queue: nil, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
    if data.length > 0 && error == nil {
    let response : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
    }
    })}
}
// Give the table number of rows
extension DetailsPage: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.couponsAll.count
    }
    
    
    // Define the table view and cell view
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView

        
        //To run the function only once
        if AppDelegate.globalValues.homePageSelection != -1 {
            let selectedDoc = selectedCoupon2()
            updateDetailInfo(selectedDoc)
            selectedRow = AppDelegate.globalValues.homePageSelection
            AppDelegate.globalValues.homePageSelection = -1
        }
        
        //put the cells there edit the image based on selected/notselected
            let couponData = self.couponsAll[row]
            cellView.textField!.stringValue = couponData.couponTitle!
            cellView.imageView!.image = NSImage(named: "scisor")
        println(selectedRow)
        if row == selectedRow {
            cellView.imageView!.image = NSImage(named: "scisor_active")
        }
        
        return cellView
        
    }
    
    //Changing the selecting color for the table
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let myCustomView = MyRowView()
        return myCustomView
    }

}

// MARK: - NSTableViewDelegate
extension DetailsPage: NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedDoc = selectedCoupon()
        updateDetailInfo(selectedDoc)
    }
}