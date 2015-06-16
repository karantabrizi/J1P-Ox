//
//  AppDelegate.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/4/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var homePage: HomePage!
    var detailsPage: DetailsPage!
    var productDP : ProductDP!
    @IBOutlet weak var window: NSWindow!
    
    struct globalValues {
        static var homePageSelection = -1
        static var toPrinter = "K"
        static var flagToHide = false
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        productDP = ProductDP(nibName: "ProductDP", bundle: nil)
        productDP.createProducts()
        window.contentView.addSubview(productDP.view)
        productDP.view.frame = (window.contentView as! NSView).bounds
        
//        detailsPage = DetailsPage(nibName: "DetailsPage", bundle: nil)
//        detailsPage.createCoupons()
//        window.contentView.addSubview(detailsPage.view)
//        detailsPage.view.frame = (window.contentView as! NSView).bounds
//        
//        homePage = HomePage(nibName: "HomePage", bundle: nil)
//        homePage.createCoupons()
//        window.contentView.addSubview(homePage.view)
//        homePage.view.frame = (window.contentView as! NSView).bounds
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
}
