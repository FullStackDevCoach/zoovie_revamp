//
//  StripeAPIClient.swift
//  Zoovie
//
//  Created by Rakesh Kumar on 10/05/19.
//  Copyright © 2019 rakesh. All rights reserved.
//

import UIKit
import Stripe

class StripeAPIClient: NSObject{//}, STPCustomerEphemeralKeyProvider {
    static let sharedClient = StripeAPIClient()
    
    var baseURLString: String? = Constant.API.BASE_DOMAIN
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("user/customerId")
        let params = [
            "api_version": apiVersion as AnyObject,
        ]
        
        
        ApiHandler.call(apiName: url.absoluteString, params: params, httpMethod: .POST) { (isSucceeded, response, data) in
            if isSucceeded == true {
                completion(response, nil)
            }else {
                completion(nil, nil)
            }
        }
    }
}
