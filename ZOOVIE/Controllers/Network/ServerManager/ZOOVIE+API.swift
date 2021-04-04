//
//  ZOOVIE+API.swift
//  ZOOVIE
//
//  Created by SFS on 26/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

extension API {
    
    struct User {
        
        static func login(email: String, password: String, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
            let parameters: [String: Any] =  ["company_id":"1", APIKey.email: email, APIKey.password: password]
            sendRequest(path: Constant.API.LOGIN, method: .post, params: parameters, completion: completion, failure: failure)
        }
        static func signup(email: String, first_name:String, last_name: String, user_name: String, password: String, phone: String, otp: String, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
           
            let parameters: [String: Any] =  [APIKey.id: "1", APIKey.firstName: first_name, APIKey.lastName: last_name, APIKey.userName: user_name, APIKey.email: email, APIKey.password: password, APIKey.lat: "", APIKey.lng: "", APIKey.deviceToken: "", APIKey.address: "", APIKey.version: "1.0", APIKey.deviceType: "IOS", APIKey.phoneNo: phone, APIKey.otpToken: otp]
                sendRequest(path: Constant.API.SIGNUP, method: .post, params: parameters, completion: completion, failure: failure)
        }
       
        static func createOTP(mobile: String, type: String, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
            print([APIKey.mobile: mobile, APIKey.type: type])
            
            sendRequest(path: Constant.API.CREATE_OTP, method: .post, params: [APIKey.mobile: mobile, APIKey.type: type], encoding: URLEncoding.default, completion: completion, failure: failure)
        }
        static func verifyOTP(otp: String, mobile: String, type: String, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
            sendRequest(path: Constant.API.VERIFY_OTP, method: .post, params: [APIKey.mobile: mobile, APIKey.type: type, APIKey.otp: type],encoding: URLEncoding.default, completion: completion, failure: failure)
        }
        static func getProfile(completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
            sendRequest(path: Constant.API.MY_PROFILE, method: .get, params: [:],encoding: URLEncoding.default, completion: completion, failure: failure)
        }
       
        static func uploadDocument(image: UIImage, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure){
            
            //uploadRequest(multipartObject: image.jpegData(compressionQuality: 0.5)!, path: Constant.API.CUSTOMER_DOCUMENT, completion: completion, failure: failure)
        }
      
        static func forgetPassword(login_id: String, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
            let parameters: [String: Any] =  [APIKey.id: 1, APIKey.email: login_id]
          
            //sendRequest(path: Constant.API.PASSWORD_FORGET, method: .post, params: parameters, completion: completion, failure: failure)
        }
      
        
        static func logout(completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
            
            sendRequest(path: Constant.API.LOGOUT, method: .post, params: nil, encoding: URLEncoding.default, completion: completion, failure: failure)
        }
    }
    
    
    // MARK: - Base API Request
    static  func sendRequest(path: String, isCompletedPath: Bool = false, method: HTTPMethod = HTTPMethod.get, params: Parameters? = nil, headers: HTTPHeaders? = HTTPHeaders.default, encoding: ParameterEncoding? = JSONEncoding.default, configuration: URLSessionConfiguration? = nil, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
        
        if !API.shared.hasConnection {
            failure(APIError.noInternetConnection)
            return
        }
        var fullUrl = Constant.API.BASE_DOMAIN.appending(path)
        if isCompletedPath {
            fullUrl = path
        }
        
        var headersForRequest: HTTPHeaders
        if let headersFromRequest = headers {
            headersForRequest = headersFromRequest
        } else {
            headersForRequest = HTTPHeaders()
        }
        
        if AppManager.sharedInstance.userToken != nil {
            headersForRequest[APIKey.authorization] = "Bearer \(AppManager.sharedInstance.userToken ?? "")"
        }
        
        headersForRequest[APIKey.contentType] = APIKey.contentTypeJson
        headersForRequest[APIKey.accept] = APIKey.contentTypeJson
       
              // headersForRequest[APIKey.client] = UIDevice.current.userInterfaceIdiom == .phone ? "iphone" : "ipad"
        // let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        // headersForRequest["User-Agent"] = "CAMELOT_ios_app_\(appVersion ?? "x")"
         
         print("========REQUEST URL ===== \(fullUrl)")
         print("========REQUEST Header ===== \( headersForRequest)")
         print("========REQUEST Params ===== \( params.debugDescription )")
        
        API.sessionManager().request(fullUrl, method: method, parameters: params, encoding: encoding!, headers: headersForRequest).responseJSON { (response) in
            handleResponse(response: response, completion: completion, failure: failure)
        }
    }
    static  func uploadRequest(multipartObject: Data, path: String, isCompletedPath: Bool = false, method: HTTPMethod = HTTPMethod.get, params: Parameters? = nil, headers: HTTPHeaders? = HTTPHeaders.default, encoding: ParameterEncoding? = JSONEncoding.default, configuration: URLSessionConfiguration? = nil, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
        
        if !API.shared.hasConnection {
            failure(APIError.noInternetConnection)
            return
        }
        var fullUrl = Constant.API.BASE_DOMAIN.appending(path)
        if isCompletedPath {
            fullUrl = path
        }
        
        var headersForRequest: HTTPHeaders
        if let headersFromRequest = headers {
            headersForRequest = headersFromRequest
        } else {
            headersForRequest = HTTPHeaders()
        }
        
       // if let token = GlobalVar.accessToken {
         //   headersForRequest[APIKey.authorization] = "Bearer \(token)"
        //}
        
        if encoding is JSONEncoding {
            headersForRequest[APIKey.contentType] = APIKey.contentTypeJson
        }
       // headersForRequest[APIKey.client] = UIDevice.current.userInterfaceIdiom == .phone ? "iphone" : "ipad"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        headersForRequest["User-Agent"] = "CAMELOT_ios_app_\(appVersion ?? "x")"
        
        print("========REQUEST URL ===== \(fullUrl)")
       print("========REQUEST Header ===== \( headersForRequest)")
        print("========REQUEST Params ===== \( params.debugDescription )")
        
        var response: DataResponse<Data?, AFError>?
        API.sessionManager().upload(multipartFormData: { multipartFormData in
           
            multipartFormData.append(multipartObject, withName: "file" , fileName: "file.jpeg", mimeType: "image/jpeg")
            
        }, to: fullUrl, method: .post, headers: headersForRequest).response { res in
            response = res
            if !API.shared.hasConnection {
                failure(APIError.noInternetConnection)
                return
            }
           print("========REQUEST Response ===== \(response.debugDescription)")
            
            if let httpCode = response?.response?.statusCode {
                if httpCode == 200 || httpCode == 204 {
                    if response?.data != nil, let json  = JSON.init(rawValue: response?.data as Any) {
                        completion(httpCode, json)
                    } else {
                        completion(httpCode, JSON.null)
                    }
                } else {
                    failure(APIError.api(httpCode,""))
                }
            } else {
                failure(APIError.api(500, "Unexpected error"))
            }
        }
    }
    static func handleResponse(response: AFDataResponse<Any>, completion: @escaping HTTPCompletion, failure: @escaping HTTPFailure) {
        if !API.shared.hasConnection {
            failure(APIError.noInternetConnection)
            return
        }
        print("========REQUEST Response ===== \(response.debugDescription)")
        
        if let httpCode = response.response?.statusCode {
            if httpCode == 200 || httpCode == 204 {
                if response.data != nil, let json  = JSON.init(rawValue: response.data as Any) {
                    completion(httpCode, json[APIKey.data])
                } else {
                    completion(httpCode, JSON.null)
                }
            } else {
                failure(APIError.api(httpCode,""))
            }
        } else {
            failure(APIError.api(500, "Unexpected error"))
        }
    }
    
}
