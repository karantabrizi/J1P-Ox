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
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        homePage = HomePage(nibName: "HomePage", bundle: nil)
        homePage.createCoupons()
        window.contentView.addSubview(homePage.view)
        homePage.view.frame = (window.contentView as! NSView).bounds
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
}

