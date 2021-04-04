//
//  API.swift
//  ZOOVIE
//
//  Created by abc on 26/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Reachability

typealias HTTPCompletion = (Int, JSON) -> Void
typealias HTTPStringCompletion = (Int, String) -> Void
typealias HTTPFailure = (APIError) -> Void //Code, Message

class API {
    static var shared = API()
    private let reachability = Reachability()

    var hasConnection: Bool {
        //return reachability.isReachable
        return true
    }

    private lazy var alamofireManager: Session? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Constant.API.timeout
        configuration.timeoutIntervalForResource = Constant.API.timeout*2
        let alamoFireManager = Alamofire.Session.init(configuration: configuration)
        return alamoFireManager

    }()
    
    static var baseURL: String {
        return Constant.API.BASE_DOMAIN
    }

    enum HttpMethod: String {
        case POST = "POST"
        case GET = "GET"
        case PUT = "PUT"
    }
    
    struct statusCodes {
        static let INVALID_ACCESS_TOKEN = 401
        static let BAD_REQUEST = 400
        static let UNAUTHORIZED_ACCESS = 401
        static let SHOW_MESSAGE = 201
        static let SHOW_DATA = 200
        static let SLOW_INTERNET_CONNECTION = 999
    }
}

// MARK: - Public Infoes

extension API {
    
    class func sessionManager() -> Session {
        return API.shared.alamofireManager!
    }

}
