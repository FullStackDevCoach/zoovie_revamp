//
//  APIError.swift
//  ZOOVIE
//
//  Created by abc on 26/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

enum APIError: Error {
    // API ( Http Code, Message)
    case api(Int,  String)
    case noInternetConnection
    case unknow
    case jsonSerializer

    func title() -> String {
        return ""
    }

    func message() -> String {
        switch self {
        case .noInternetConnection:
            return "Internet connection error"
        case .api(_, let message):
            if message.isEmpty {
                return "Internal server error"
            }
            return message
        default:
            return "Internal server error"
        }
    }

    func code() -> Int {
        switch self {
        case .noInternetConnection:
            return -1
        case .api(let code, _):
            return code
        default:
            return -999
        }
    }
}

