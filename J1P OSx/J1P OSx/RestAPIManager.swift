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

    var baseURL = "http://api.jcpenney.com/v2/\(AppDelegate.globalValues.keyWord)"
    
    func getProducts(onCompletion: (JSON) -> Void) {
        var route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err -> Void in
            onCompletion(json as JSON)
        })}
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        var request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        var session = NSURLSession.sharedSession()
        
        var task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            var json:JSON = JSON(data: data)
            onCompletion(json,error)
        })
        task.resume()
    }
}