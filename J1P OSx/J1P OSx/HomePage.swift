//
//  HomePage.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/4/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Cocoa

class HomePage: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    var coupons = [CouponData]()
    let count=5
    
    func createCoupons() {
        
        for index in 1...count {
    
    var coupon = CouponData (couponID: index, couponTitle: "Coupon\(index)", couponCode: "ABCDEFGH", couponDiscount: 20, couponImage: NSImage(named:"coupon\(index)"))
            
            coupons.append(coupon)
        
//    var coupon2 = CouponData (couponID: 1, couponTitle: "Coupon1", couponCode: "NOWSHOP", couponDiscount: 20, couponImage: NSImage(named:"coupon3"))
            }
        }
}
// Give the table number of rows
extension HomePage: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.coupons.count
    }
    
    @IBAction func TestButton(sender: NSButton) {
        println("Hello")
    }
// Define the table view and cell view
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
// Setting what each column does
        if tableColumn!.identifier == "LeftColumn" {

            let couponData = self.coupons[row]
            cellView.imageView!.image = couponData.couponImage
            cellView.textField!.stringValue = couponData.couponTitle!
            return cellView
        }
        if tableColumn!.identifier == "RightColumn" {
            let couponData = self.coupons[row]
            cellView.imageView!.image = couponData.couponImage
            cellView.textField!.stringValue = couponData.couponTitle!
            return cellView
        }
        
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension HomePage: NSTableViewDelegate {
}