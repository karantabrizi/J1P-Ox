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
    
//    Trying to fix the column issue
    @IBOutlet weak var rightColumn: NSTableColumn!
    @IBAction func imageViewRight(sender: AnyObject) {
        println("image is taking action!")
    }

    //Sanity check for the coupon selection
    func selectedCoupon() {
        let selectedCol = self.tableView.selectedColumn
        println("selectedCol \(selectedCol)")
        let selectedRow = self.tableView.selectedRow
        if selectedRow >= 0 && selectedRow < self.couponsLeft.count {

            AppDelegate.globalValues.homePageSelection = selectedRow
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        
        return cellView
    }
    
    func tableView(tableView: NSTableView, shouldSelectTableColumn tableColumn: NSTableColumn?) -> Bool {
        return true
    }
    
}

// MARK: - NSTableViewDelegate
extension HomePage: NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        selectedCoupon()
        self.view.hidden = true
        NSNotificationCenter.defaultCenter().postNotificationName("refreshMyTableView", object: nil)
    }
}