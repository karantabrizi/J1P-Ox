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
    var productID: Int?
    var productName: String?
    var productSize: String?
    var productColor: String?
    var productImage: NSImage?
    var productThumb: NSImage?
    var productLongDescription: String?
    var productShortDescription: String?
    var productPrice: Double?

    
    init( productID: Int?, productName: String?, productSize: String?, productColor: String?, productImage: NSImage?, productThumb: NSImage?, productLongDescription: String?, productShortDescription: String?, productPrice: Double?) {
        self.productID = productID
        self.productName = productName
        self.productSize = productSize
        self.productColor = productColor
        self.productImage = productImage
        self.productThumb = productThumb
        self.productLongDescription = productLongDescription
        self.productShortDescription = productShortDescription
        self.productPrice = productPrice
    }
    
}

