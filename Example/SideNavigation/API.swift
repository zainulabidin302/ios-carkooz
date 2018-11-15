//
//  API.swift
//  SideNavigation_Example
//
//  Created by apple on 11/8/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class API {
    class func  requestHelper(_ endpoint: String, body: Data, boundry: String) -> URLRequest {
        var request = URLRequest(url: URL(string:  AppDelegate.baseURL + endpoint)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundry)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
    
    static  func createBody(parameters: [String: String],
                            boundry: String,
                data: Data?,
                mimeType: String,
                filename: String) -> Data {
    let body = NSMutableData()

        let boundaryPrefix = "--\(boundry)\r\n"
    
    for (key, value) in parameters {
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString("\(value)\r\n")
    }
    
    body.appendString(boundaryPrefix)
    body.appendString("Content-Disposition: form-data; name=\"files[]\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimeType)\r\n\r\n")
    body.append(data!)
    body.appendString("\r\n")
        body.appendString("--".appending(boundry.appending("--")))
    
    return body as Data
}
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
