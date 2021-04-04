//
//  ApiHandler.swift
//  ZOOVIE
//
//  Created by SFS on 29/05/20.
//  Copyright © 2020 Zoovie. All rights reserved.
//

import UIKit

class ApiHandler {

    static public func call(apiName:String,params: [String : Any]?,httpMethod:API.HttpMethod,receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        
        //print(apiName)
        //print(params)
        
        if API.shared.hasConnection == true {
            HttpManager.requestToServer(apiName, params: params ?? [:], httpMethod: httpMethod, isZipped: false, receivedResponse: { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["statusCode"] as? Int {
                            switch(status) {
                            case API.statusCodes.SHOW_DATA:
                                receivedResponse(true, response, data)
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                AppManager.sharedInstance.showTopAlert(alertMessage: AlertMessage.INVALID_ACCESS_TOKEN)
                                AppDelegate.sharedDelegate.goToSplashVC()
                                //Singleton.sharedInstance.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                //Singleton.sharedInstance.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                             default:
                                if let message = response["data"] as? String {
                                    receivedResponse(false, ["statusCode":status, "message":message], nil)
                                } else {
                                    receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            })
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
    }
    static public func uploadImage(apiName:String, imageArray:[UIImage]?, imageKey:String, params: [String : Any]?, isImage:Bool = true, receivedResponse:@escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if API.shared.hasConnection == true {
            
            HttpManager.uploadingMultipleTask(apiName, params: params!, isImage: isImage, imageData: imageArray, imageKey: imageKey) { (isSucceeded, response, data) in
               
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["statusCode"] as? Int {
                            switch(status) {
                            case API.statusCodes.SHOW_DATA:
                                receivedResponse(true, response, data)
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                
                                //Singleton.sharedInstance.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                //Singleton.sharedInstance.gotoSplash()
                                receivedResponse(false, [:], nil)
                            default:
                                if let message = response["data"] as? String {
                                    receivedResponse(false, ["statusCode":status, "message":message], nil)
                                } else {
                                    receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
        
    }
    
}
