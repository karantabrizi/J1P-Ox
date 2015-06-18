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
        var productImage = ""
        var productName = ""
//        var productColor = ""
//        var productSize = ""
//        var productLongDescription = ""
//        var productShortDescription = ""
        var productPrice = ""
        
        if let ProductsData = doc {
            productImage = ProductsData.productImage!
            productName = ProductsData.productName!
//            productColor = ProductsData.productColor!
//            productSize = ProductsData.productSize!
//            productLongDescription = ProductsData.productLongDescription!
//            productShortDescription = ProductsData.productShortDescription!
            productPrice = ProductsData.productPrice!
        }
        
        var url = NSURL(string: productImage)
        if var data = NSData(contentsOfURL: url!){
            self.productImage.image = NSImage(data: data)}
        self.productName.stringValue = productName
//        self.productColor.stringValue = productColor
//        self.productSize.stringValue = productSize
//        self.productLongDescription.stringValue = productLongDescription
//        self.productShortDescription.stringValue = productShortDescription
        self.productPrice.stringValue = productPrice
    }
    
    //Creating the data array
    var sampleProducts = [ProductsData]()
    func createProducts() {
        for index in 0...counter {
        var product = ProductsData(productID: jsonProductID[index], productName: jsonProductName[index], /*productSize: "9", productColor: "Gray", */productImage: jsonProductImage[index], /*productThumb: NSImage(named: "product1t"), productLongDescription: "An intricate outline of floral patterns turns our iconic Converse sneakers into a stylish shoe that spices up your outfit.", productShortDescription: "nice shoes",*/ productPrice: jsonProductPrice[index], productUrl: jsonProductUrl[index])
        sampleProducts.insert(product, atIndex: index)
    }
    }
    
//    //Configuring built in Search
//    var finalArray = [0]
//    @IBOutlet weak var searchedWord: NSSearchFieldCell!
//    @IBAction func searchField(sender: NSSearchField) {
//        
//        var keyWord = searchedWord.title
//            finalArray = [0]
//            createProducts()
//        
//            for product in sampleProducts {
//                if keyWord == "" {break}
//                //optimize by removing products that are already in
//                //loop to find the word in each string
//                while 1<count(product.productName!) {
////                  if finalArray[finalArray.count - 1] == product {
//                    if product.productName!.hasSuffix(keyWord){
//                        finalArray += [product.productID!]
//                        break}
//                    else {product.productName!.removeAtIndex(product.productName!.endIndex.predecessor())}
////                  }
//                    }
    
        //creating the table array of dummy products
//        createProducts()
//        var workingArray = sampleProducts
//        sampleProducts = []
//        for product in workingArray {
//            for ID in finalArray {
//                if product.productID == ID {
//                    sampleProducts.append(product)
//                }
//            }
//        }
//        productTable.reloadData()
//        }
//        }
    
    var jsonProductName : [String] = []
    var jsonProductUrl : [String] = []
    var jsonProductID : [String] = []
    var jsonProductImage : [String] = []
    var jsonProductPrice : [String] = []
    var jsonProductLongDescription = ""
    var data = NSData.self
    var count = 0
    var counter = 0
    
    func getJSON () {
        RestAPIManager().getProducts{ json in
            self.count = json["count"].numberValue.integerValue
            var products = json["products"].arrayValue
            for item in products {
                var productObject = item.dictionaryValue
                self.jsonProductName.insert(productObject["name"]!.stringValue, atIndex : self.counter)
                self.jsonProductUrl.insert(productObject["url"]!.stringValue, atIndex : self.counter)
                self.jsonProductID.insert(productObject["id"]!.stringValue, atIndex : self.counter)
                var images = productObject["images"]!.arrayValue
                var imagesObject = images[0].dictionaryValue
                self.jsonProductImage.insert(imagesObject["url"]!.stringValue + "?wid=180&hei=180&op_usm=.4,.8,0,0&resmode=sharp2", atIndex : self.counter)
                var prices = productObject["prices"]!.arrayValue
                var pricesObject = prices[0].dictionaryValue
                self.jsonProductPrice.insert(pricesObject["max"]!.stringValue, atIndex : self.counter)

                if (self.counter > self.count-2) || (self.counter > 3) {break}
                self.counter += 1
            }
        }
    }
    
    //to be moved to the func above
    func getProductInfo () {
        RestAPIManager().getProducts{ json in
            self.jsonProductLongDescription = json["description"].stringValue
        }
    }

    //creating the table array
    @IBOutlet weak var searchedWord: NSSearchFieldCell!
    @IBAction func searchField(sender: NSSearchField) {
        self.jsonProductName = []
        self.jsonProductUrl = []
        self.jsonProductID = []
        self.jsonProductImage = []
        self.jsonProductPrice = []
        self.counter = 0
        if searchedWord.stringValue != "" {
            AppDelegate.globalValues.keyWord = searchedWord.title
            getJSON()
            sleep(3)
            createProducts()
            productTable.reloadData()
        } else {
            sampleProducts = []
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
        cellView.textField!.stringValue = sampleProducts[row].productName!
        var url = NSURL(string: sampleProducts[row].productImage!)
        if var data = NSData(contentsOfURL: url!){
            cellView.imageView!.image = NSImage(data: data)}
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
        var selectedDoc = selectedProduct()
        updateDetailInfo(selectedDoc)
    }
}
