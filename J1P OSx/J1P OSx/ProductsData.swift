//
//  ProductsData.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/15/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Foundation
import AppKit

class ProductsData: NSObject {
    var productID: String?
    var productName: String?
//    var productSize: String?
//    var productColor: String?
    var productImage :  String?
//    var productThumb: NSImage?
//    var productLongDescription: String?
//    var productShortDescription: String?
    var productPrice: String?
    var productUrl: String?

    
    init( productID: String?, productName: String?, /*productSize: String?, productColor: String?, */productImage: String?, /*productThumb: NSImage?, productLongDescription: String?, productShortDescription: String?, */productPrice: String?, productUrl: String?) {
        self.productID = productID
        self.productName = productName
//        self.productSize = productSize
//        self.productColor = productColor
        self.productImage = productImage
//        self.productThumb = productThumb
//        self.productLongDescription = productLongDescription
//        self.productShortDescription = productShortDescription
        self.productPrice = productPrice
        self.productUrl = productUrl
    }
    
}

