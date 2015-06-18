//
//  RestAPIManager.swift
//  J1P OSx
//
//  Created by karan tabrizi on 6/17/15.
//  Copyright (c) 2015 karan tabrizi. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestAPIManager: NSObject {
    static let sharedInstance = RestAPIManager()
    
    let baseURL = "http://api.jcpenney.com/v2/search?q=sh"
    
    func getProducts(onCompletion: (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err -> Void in
            onCompletion(json as JSON)
        })}
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json,error)
        })
        task.resume()
    }
}