//
//  APIHelperController.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/24/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import Foundation
import Alamofire

protocol APIHelperControllerDelegate {
    func onSuccess(api: String, response: Response<AnyObject, NSError>)
    func onFailed(api: String)
}

class APIHelperController {
    var apiHelperDelegate: APIHelperControllerDelegate!    
    
    func requestPostAPIs(apiUrl: String, parameter: [String : AnyObject]) {
        Alamofire.request(.POST, apiUrl, parameters: parameter)
            .responseJSON { response in
                if response.result.isSuccess {
                    if self.apiHelperDelegate != nil {
                        self.apiHelperDelegate.onSuccess(apiUrl, response: response)
                    }
                } else {
                    if self.apiHelperDelegate != nil {
                        self.apiHelperDelegate.onFailed(apiUrl)
                    }
                }
        }
    }
    
    func requestPutAPIs(apiUrl: String, parameter: [String: AnyObject]){
        Alamofire.request(.PUT, apiUrl, parameters: parameter)
            .responseJSON { response  in
                if response.result.isSuccess {
                    if self.apiHelperDelegate != nil {
                        self.apiHelperDelegate.onSuccess(apiUrl, response: response)
                    }
                } else {
                    if self.apiHelperDelegate != nil {
                        self.apiHelperDelegate.onFailed(apiUrl)
                    }
                }
            }
    }
    
    func requestGetAPIs(apiUrl: String, parameter: [String: AnyObject]){
        Alamofire.request(.GET, apiUrl, parameters: parameter)
            .responseJSON { response in
                if response.result.isSuccess {
                    if self.apiHelperDelegate != nil {
                        self.apiHelperDelegate.onSuccess(apiUrl, response: response)
                    }
                } else {
                    if self.apiHelperDelegate != nil {
                        self.apiHelperDelegate.onFailed(apiUrl)
                    }
                }
            }
    
    }
}
