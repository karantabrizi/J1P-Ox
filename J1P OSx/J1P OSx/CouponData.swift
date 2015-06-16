//
//  CouponData.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/4/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Foundation
import AppKit

class CouponData: NSObject {
    var couponID: Int?
    var couponTitle: String?
    var couponExpiration: String?
    var couponDiscount: Int?
    var couponImage: NSImage?
    
    init( couponID: Int?, couponTitle: String?, couponCode: String?, couponDiscount: Int?, couponImage: NSImage?){
    self.couponID = couponID
    self.couponTitle = couponTitle
    self.couponExpiration = couponCode
    self.couponDiscount = couponDiscount
    self.couponImage = couponImage
    }
}
