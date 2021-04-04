//
//  HttpManager.swift
//  ZOOVIE
//
//  Created by SFS on 29/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class HttpManager {
    static public func requestToServer(_ url: String, params: [String:Any], httpMethod: API.HttpMethod, isZipped:Bool, receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any],_ data:Data?) -> ()){
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: Constant.API.BASE_DOMAIN + urlString!)!)
        //print(request.url)
        //print(request.allHTTPHeaderFields)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = 20
        var accessToken = ""
        if AppManager.sharedInstance.userToken != nil {
            accessToken = AppManager.sharedInstance.userToken ?? ""
        }
        
        if accessToken.count > 0 {
            request.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")
            print(accessToken)
            
        }
        if(httpMethod == API.HttpMethod.POST || httpMethod == API.HttpMethod.PUT) {
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            if isZipped == false {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
                request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Encoding: gzip")
            }
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if(response != nil && data != nil) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                        receivedResponse(true, json, data)
                    } else {
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)    // No error thrown, but not NSDictionary
                        print("Error could not parse JSON: \(jsonStr ?? "")")
                        receivedResponse(false, [:], nil)
                    }
                } catch let parseError {
                    print(parseError)                                                          // Log the error thrown by `JSONObjectWithData`
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: '\(jsonStr ?? "")'")
                    receivedResponse(false, [:], nil)
                }
            } else {
                receivedResponse(false, [:], nil)
            }
        }
        task.resume()
    }

    static public func serverCall(_ url: String, params: [String:Any], httpMethod: API.HttpMethod, isZipped:Bool, receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any],_ statusCode:Int) -> ()) {
       
        if API.shared.hasConnection == true {
            HttpManager.requestToServer(url, params: params, httpMethod: httpMethod, isZipped: isZipped) { (success, response, data) in
                if success == true {
                    if let status = response["statusCode"] as? Int {
                        switch(status) {
                        case API.statusCodes.SHOW_DATA:
                            receivedResponse(true, response, status)
                        case API.statusCodes.INVALID_ACCESS_TOKEN:
                            if let message = response["customMessage"] as? String {
                                receivedResponse(true, ["statusCode":status, "customMessage":message], status)
                            } else {
                                receivedResponse(true, ["statusCode":status, "customMessage":ERROR_MESSAGE.INVALID_ACCESS_TOKEN], status)
                            }
//                        case STATUS_CODES.SHOW_MESSAGE:
//                            if let message = response["message"] as? String {
//                                receivedResponse(false, ["statusCode":status, "message":message], status)
//                            } else {
//                                receivedResponse(false, ["statusCode":status, "message":ERROR_MESSAGE.SERVER_NOT_RESPONDING], status)
//                            }
                        default:
                            if let message = response["message"] as? String {
                                receivedResponse(false, ["statusCode":status, "message":message], status)
                            } else {
                                receivedResponse(false, ["statusCode":status, "message":ERROR_MESSAGE.SOMETHING_WRONG], status)
                            }
                        }
                    } else {
                         receivedResponse(false, ["statusCode":0, "message":ERROR_MESSAGE.SOMETHING_WRONG], 0)
                    }
                } else {
                    receivedResponse(false, ["statusCode":0, "message":ERROR_MESSAGE.SOMETHING_WRONG], 0)
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":ERROR_MESSAGE.NO_INTERNET_CONNECTION], 0)
        }
    }
    
    static public func uploadingMultipleTask(_ url:String, params: [String:Any], isImage:Bool, imageData:[UIImage]?, imageKey:String, receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any],_ data:Data?) -> ())
    {
        let boundary:NSString = "----WebKitFormBoundarycC4YiaUFwM44F6rT"
        let body:NSMutableData = NSMutableData()
        let paramsArray = params.keys
        for item in paramsArray {
            body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("Content-Disposition: form-data; name=\"\(item)\"\r\n\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            body.append("\(params[item]!)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        }
        if(isImage) {
            for i in (0..<imageData!.count) {
                body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"photoName.jpeg\"\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                if let image = imageData?[i] {
                    if let dataValue = image.jpegData(compressionQuality: 0.5) {
                        body.append(dataValue)
                    }
                }
                body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: Constant.API.BASE_DOMAIN + urlString!)!)
        print(request.url)
        request.httpMethod = "POST"
        request.httpBody = body as Data
        request.timeoutInterval = 60
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var accessToken = ""
        if AppManager.sharedInstance.userToken != nil {
            accessToken = AppManager.sharedInstance.userToken ?? ""
        }
        if accessToken.count > 0 {
            request.setValue("\(accessToken)", forHTTPHeaderField: "Authorization")
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if(response != nil) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String:Any] {
                        receivedResponse(true, json, data)
                    } else {
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)    // No error thrown, but not NSDictionary
                        print("Error could not parse JSON: \(jsonStr ?? "")")
                        receivedResponse(false, [:], nil)
                    }
                } catch let parseError {
                    print(parseError)                                                          // Log the error thrown by `JSONObjectWithData`
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: \(jsonStr ?? "")")
                    receivedResponse(false, [:], nil)
                }
            } else {
                receivedResponse(false, [:], nil)
            }
        })
        task.resume()
    }
    
}

