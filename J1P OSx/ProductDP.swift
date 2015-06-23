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
    
    
    @IBOutlet weak var noSearchResult: NSTextField!
    @IBOutlet weak var productTable: NSTableView!
    @IBOutlet weak var productImage: NSImageView!
    @IBOutlet weak var productName: NSTextField!
    @IBOutlet weak var productColor: NSTextField!
    @IBOutlet weak var productSize: NSTextField!
    @IBOutlet weak var productLongDescription: NSTextField!
    @IBOutlet weak var productShortDescription: NSTextField!
    @IBOutlet weak var productPrice: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!

    
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
        var productLongDescription = ""
//        var productShortDescription = ""
        var productPrice = ""
        
        if let ProductsData = doc {
            productImage = ProductsData.productImage!
            productName = ProductsData.productName!
//            productColor = ProductsData.productColor!
//            productSize = ProductsData.productSize!
            productLongDescription = ProductsData.productLongDescription!
//            productShortDescription = ProductsData.productShortDescription!
            productPrice = ProductsData.productPrice!
        }
        
        var url = NSURL(string: productImage)
        if var data = NSData(contentsOfURL: url!){
            self.productImage.image = NSImage(data: data)}
        self.productName.stringValue = productName
//        self.productColor.stringValue = productColor
//        self.productSize.stringValue = productSize
        self.productLongDescription.stringValue = productLongDescription.html2String
//        self.productShortDescription.stringValue = productShortDescription
        self.productPrice.stringValue = productPrice
    }
    
    //Creating the data array
    var sampleProducts = [ProductsData]()
    func createProducts() {
        sampleProducts = []
        for index in 0...counter {
        var product = ProductsData(productID: jsonProductID[index], productName: jsonProductName[index], productImage: jsonProductImage[index], productLongDescription: jsonProductLongDescription[index], productPrice: jsonProductPrice[index], productUrl: jsonProductUrl[index])
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
    var jsonProductLongDescription : [String] = []/*[String](count: 5, repeatedValue : "")*/
    var data = NSData.self
    var count = 0
    var counter = 0
    
    //Get the serach results from API
    func getJsonProduct () {
        self.jsonProductLongDescription = Array(count: 5, repeatedValue : " ")
        RestAPIManager().getProducts{ json in
            self.count = json["count"].numberValue.integerValue
            println(self.count)
            if self.count == 0 {return}
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
    
    //Parsing the product details json
    func getJsonDetail () {
        AppDelegate.globalValues.keyWord = self.jsonProductUrl[self.productTable.selectedRow]/*.substringFromIndex(advance(self.jsonProductUrl[self.productTable.selectedRow].startIndex,30))*/
        RestAPIManager().getProducts{ json in
            println(self.productTable.selectedRow)
            self.jsonProductLongDescription[self.productTable.selectedRow] = json["description"].stringValue
        }
    }
    
    //converting character "space" to "%20"
    func convertSpaceCharacter () {
        var toArray = searchedWord.stringValue.componentsSeparatedByString(" ")
        AppDelegate.globalValues.keyWord  = join("%20", toArray)
        AppDelegate.globalValues.keyWord = "http://api.jcpenney.com/v2/search?q=\(AppDelegate.globalValues.keyWord)"
    }
    
    //Deleting Previous Values
    func clearProductList() {
        self.jsonProductName = []
        self.jsonProductUrl = []
        self.jsonProductID = []
        self.jsonProductImage = []
        self.jsonProductPrice = []
//        self.jsonProductLongDescription = []
        self.counter = 0
    }
    func clearProductDetailsPage () {
        self.productImage.image = NSImage()
        self.productName.stringValue = ""
        //        productColor: NSTextField!
        //        productSize: NSTextField!
        self.productLongDescription.stringValue = ""
        //        productShortDescription: NSTextField!
        self.productPrice.stringValue = ""
    }
    
    //creating the table array
    @IBOutlet weak var searchedWord: NSSearchFieldCell!
    @IBAction func searchField(sender: NSSearchField) {
        if searchedWord.stringValue != "" {
            self.progressIndicator.startAnimation(self)
            clearProductList()
            clearProductDetailsPage ()
            convertSpaceCharacter()
            getJsonProduct()
            sleep(3)
            
            //If no result comes back from search
            if self.count == 0 {
                self.noSearchResult.stringValue = "There is no result searching for \"\(searchedWord.title)\"."
                return
            }
            else {
                self.noSearchResult.stringValue = ""
            }
            
            createProducts()
            productTable.reloadData()
        } else {
            clearProductDetailsPage()
        }
        self.progressIndicator.stopAnimation(self)
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
            cellView.textField!.textColor = NSColor.redColor()
//            cellView.textField!.backgroundColor = NSColor.whiteColor()
            selectedRow = -1
        } else { cellView.textField!.textColor = NSColor.blackColor() }
        return cellView
    }
    
    //Changing the selecting color for the table
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let myCustomView = MyRowView()
        return myCustomView
    }
    
}

// MARK: - NSTableViewDelegate
extension ProductDP: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        clearProductDetailsPage()
        self.progressIndicator.startAnimation(self)
        if self.jsonProductLongDescription[self.productTable.selectedRow] == " " {
            getJsonDetail()
            sleep(3)
            createProducts()
        }
        var selectedDoc = selectedProduct()
        updateDetailInfo(selectedDoc)
        self.progressIndicator.stopAnimation(self)
    }
}