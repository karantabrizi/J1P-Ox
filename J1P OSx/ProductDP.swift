//
//  ProductDP.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/15/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

class ProductDP: NSViewController {
    
    var box = ("<p>Outfit your bathroom with soft new carpet from this rug collection featuring a nonskid latex back.</p>\r\n<ul>\r\n\t<li>\r\n\t\tvibrant, lasting color&mdash;wash after wash</li>\r\n\t<li>\r\n\t\tstain resistant</li>\r\n\t<li>\r\n\t\tultra soft</li>\r\n\t<li>\r\n\t\tcoordinates with Signature Soft Solid and Damask towels</li>\r\n</ul>\r\n<p>Nylon. Washable. Made in America.</p>\r\n<ul>\r\n\t<li>\r\n\t\tOblong rugs: available in 17x24&rdquo;, 20x34&rdquo;, 24x40&quot;, 30x50&quot; and 20x60&quot;</li>\r\n\t<li>\r\n\t\tContour rug (fits around toilet base): 20x24&quot;</li>\r\n\t<li>\r\n\t\tStandard Lid Cover: 17x19&quot;</li>\r\n\t<li>\r\n\t\tElongated Lid Cover: 17x21&quot;</li>\r\n\t<li>\r\n\t\tTank set: 13x27&quot; and 15x39&quot;</li>\r\n\t<li>\r\n\t\tCarpets: 60x72&quot; and 72x120&quot;</li>\r\n</ul>\r\n<p>Note:&nbsp;60x72&quot; is a 5x6&#39; carpet and 72x120&quot; is a 6x10&#39; carpet. Both can be cut to fit the size of your bathroom.</p>\r\n".html2String)
    
    @IBOutlet var labelBox: NSTextFieldCell!
    
    @IBOutlet weak var productTable: NSTableView!
    @IBOutlet weak var productImage: NSImageView!
    @IBOutlet weak var productName: NSTextField!
    @IBOutlet weak var productColor: NSTextField!
    @IBOutlet weak var productSize: NSTextField!
    @IBOutlet weak var productLongDescription: NSTextField!
    @IBOutlet weak var productShortDescription: NSTextField!
    @IBOutlet weak var productPrice: NSTextField!
    
    //Notification to hide the search page
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideSearch:", name:"hideMySearch", object: nil)
    }
    func hideSearch(notification: NSNotification){
        self.view.hidden = AppDelegate.globalValues.flagToHideSearch
        productTable.reloadData()
    }
    
    //Selection funtionality
    var selectedRow = -1
    func selectedProduct() -> ProductsData? {
        selectedRow = self.productTable.selectedRow;
        if selectedRow >= 0 && selectedRow < self.sampleProducts.count {
            productTable.reloadData()
            return self.sampleProducts[selectedRow]
        }
        return nil
    }
    
    //Initialize the Lables showing on the coupon details and update by selection
    func updateDetailInfo(doc: ProductsData?) {
        var productImage : NSImage?
        var productName = ""
        var productColor = ""
        var productSize = ""
        var productLongDescription = ""
        var productShortDescription = ""
        var productPrice = 0.0
        
        if let ProductsData = doc {
            productImage = ProductsData.productImage!
            productName = ProductsData.productName!
            productColor = ProductsData.productColor!
            productSize = ProductsData.productSize!
            productLongDescription = ProductsData.productLongDescription!
            productShortDescription = ProductsData.productShortDescription!
            productPrice = ProductsData.productPrice!
        }
        
        self.productImage.image = productImage
        self.productName.stringValue = productName
        self.productColor.stringValue = productColor
        self.productSize.stringValue = productSize
        self.productLongDescription.stringValue = productLongDescription
        self.productShortDescription.stringValue = productShortDescription
        self.productPrice.doubleValue = Double(productPrice)
        self.labelBox.stringValue = box
    }
    
    //Creating the data array
    var sampleProducts = [ProductsData]()
    func createProducts() {
    var product1 = ProductsData(productID: 1, productName: "Converse", productSize: "9", productColor: "Gray", productImage: NSImage(named: "product1"), productThumb: NSImage(named: "product1t"), productLongDescription: "An intricate outline of floral patterns turns our iconic Converse sneakers into a stylish shoe that spices up your outfit.", productShortDescription: "nice shoes", productPrice: 59.99)
    var product2 = ProductsData(productID: 2, productName: "shoe", productSize: "8", productColor: "White", productImage: NSImage(named: "product2"), productThumb: NSImage(named: "product2t"), productLongDescription: "Long description for product2", productShortDescription: "not as nice shoes", productPrice: 29.99)
    var product3 = ProductsData (productID: 3, productName: "shirt", productSize: "Large", productColor: "Blue", productImage: NSImage(named: "product3"), productThumb: nil, productLongDescription: "long description for shirt", productShortDescription: "A Blue shirt", productPrice: 40.00)
    return sampleProducts = [product1,product2,product3]
    }
    
    //Configuring Search
    var finalArray = [0]
    @IBOutlet weak var searchedWord: NSSearchFieldCell!
    @IBAction func searchField(sender: NSSearchField) {
        
        var keyWord = searchedWord.title
            finalArray = [0]
            createProducts()
        
            for product in sampleProducts {
                if keyWord == "" {break}
                //optimize by removing products that are already in
                //loop to find the word in each string
                while 1<count(product.productName!) {
//                  if finalArray[finalArray.count - 1] == product {
                    if product.productName!.hasSuffix(keyWord){
                        finalArray += [product.productID!]
                        break}
                    else {product.productName!.removeAtIndex(product.productName!.endIndex.predecessor())}
//                  }
                    }
            
        //creating the table array
        createProducts()
        var workingArray = sampleProducts
        sampleProducts = []
        for product in workingArray {
            for ID in finalArray {
                if product.productID == ID {
                    sampleProducts.append(product)
                }
            }
        }
        productTable.reloadData()
        }
        }
    //HomeButton function
    @IBAction func homeButton(sender: NSButton) {
        AppDelegate.globalValues.flagToHideHome = false
        NSNotificationCenter.defaultCenter().postNotificationName("hideHomePage", object: nil)
        AppDelegate.globalValues.flagToHideSearch = true
        NSNotificationCenter.defaultCenter().postNotificationName("hideMySearch", object: nil)
    }
    
    
    
}




// Give the table number of rows
extension ProductDP: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.sampleProducts.count
}

    // Define the table view and cell view
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView

        //put the cells there edit the image based on selected/notselected
        let productsData = self.sampleProducts[row]
        cellView.textField!.stringValue = productsData.productName!
        cellView.imageView!.image = productsData.productImage
        if row == selectedRow {
            cellView.textField!.stringValue = "SELECTED"
            selectedRow = -1
        }
        return cellView
    }
}

// MARK: - NSTableViewDelegate
extension ProductDP: NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedDoc = selectedProduct()
        updateDetailInfo(selectedDoc)
    }
}
