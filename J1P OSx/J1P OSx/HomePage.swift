//
//  HomePage.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/4/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Cocoa
import AppKit

class HomePage: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!

    var selectedRow = -1
    var selectedCol = -1
    var leftColSel = 0
    var rightColSel = 0
    //Sanity check for the coupon selection
    func selectedCoupon() {
        let selectedRow = self.tableView.selectedRow
        if selectedRow >= 0 && selectedRow < self.couponsLeft.count {
            if leftColSel % 2 == 0 {
            AppDelegate.globalValues.homePageSelection = selectedRow * 2 + 1
            } else { AppDelegate.globalValues.homePageSelection = selectedRow * 2 }
        }
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hidePage:", name:"hideHomePage", object: nil)
        AppDelegate.globalValues.flagToHideSearch = true
        AppDelegate.globalValues.flagToHideDetails = true
        NSNotificationCenter.defaultCenter().postNotificationName("refreshMyTableView", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("hideMySearch", object: nil)
    }
    func hidePage(notification: NSNotification){
        self.view.hidden = AppDelegate.globalValues.flagToHideHome
        //to remove previous selection
        tableView.reloadData()
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
    
    //Initializing coupon arrays 
    var couponsLeft = [CouponData]()
    var couponsRight = [CouponData]()
    
    func createCoupons() {
        
        let numberOfCoupons=6
        
        // Creating coupons and put them in two arrays for two columns
        for index in 1...numberOfCoupons {
    
    var coupon = CouponData (couponID: index, couponTitle: "Coupon\(index)", couponCode: "ABCDEFGH", couponDiscount: 20, couponImage: NSImage(named:"coupon\(index)"))
            
            // Separating the coupons for left and right column
            if index%2 == 1 {couponsLeft.append(coupon)
            } else {couponsRight.append(coupon)}
        
            }
        
        // Preventing Errors if the columns are not the same size by repeating the last coupon
        if couponsLeft.count != couponsRight.count
        { couponsRight.append(couponsLeft.last!)}
    }
    //get JSON --------------------------------------------
        @IBAction func json(sender: NSButton) {
        RestAPIManager.sharedInstance.getProducts{ json in
            let count = json["count"].numberValue.integerValue
            println(count)
            let products = json["products"].arrayValue
            var x = 0
            for item in products {
                let oneObj = item.dictionaryValue
                let name = oneObj["name"]!.stringValue
                let url = oneObj["url"]!.stringValue
                let id = oneObj["id"]!.stringValue
                x += 1
                if x>count {break}
            }
        }
    }
}
// Give the table number of rows
extension HomePage: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.couponsLeft.count
    }
    
// Define the table view and cell view
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
// Setting what each column does
        if tableColumn!.identifier == "LeftColumn" {
            
            let couponData = self.couponsLeft[row]
            cellView.imageView!.image = couponData.couponImage
            cellView.textField!.stringValue = couponData.couponTitle!
            return cellView
        }
        if tableColumn!.identifier == "RightColumn"{
            
            let couponData = self.couponsRight[row]
            cellView.imageView!.image = couponData.couponImage
            cellView.textField!.stringValue = couponData.couponTitle!
            return cellView
        }
        selectedRow = -1
        return cellView
    }
    @IBAction func leftColumnCheck(sender: NSButton) {
        leftColSel += 1
//        println("left is \(leftColSel)")
    }
    @IBAction func rightColumnCheck(sender: NSButton) {
        rightColSel += 1
//        println("right is \(rightColSel)")
    }

}

// MARK: - NSTableViewDelegate
extension HomePage: NSTableViewDelegate {
        func tableViewSelectionDidChange(notification: NSNotification) {
            if (leftColSel + rightColSel) % 2 == 1 {
                selectedCoupon()
                AppDelegate.globalValues.flagToHideHome = true
                AppDelegate.globalValues.flagToHideSearch = true
                AppDelegate.globalValues.flagToHideDetails = false
                NSNotificationCenter.defaultCenter().postNotificationName("hideHomePage", object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("refreshMyTableView", object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("hideMySearch", object: nil)
            }
    }
}