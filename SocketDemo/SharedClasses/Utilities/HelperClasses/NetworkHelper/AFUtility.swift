//
//  AFUtility.swift
//  MoDDA
//
//  Created by Jayesh on 23/05/17.
//  Copyright © 2017 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import Alamofire

let key_Failure_Error = "Something went wrong."

typealias CompletionHandler = (_ response: NSDictionary?, _ statusCode: Int?, _ error: NSError?) -> Void

class AFUtility: NSObject {

    static let sharedInstance = AFUtility()
    
    func doRequestFor(_ url : String, method: HTTPMethod, dicsParams : [String: Any]?, dicsHeaders : [String: String]?, completionHandler:@escaping CompletionHandler) {
        
        if NetworkReachablity().isNetwork(){
            showAlertWithTitle(CommonConstants.AlertTitle, message: CommonConstants.noInternetMsg)
            completionHandler(nil,nil,nil)
            return
        }

        var dictHeaders:[String:String]? = nil
//        if sharedUserHelper.sessionToken() != nil{
//            dictHeaders = ["Authorization":"Bearer \(sharedUserHelper.sessionToken()!)"];
//        }
        
        if (dicsParams != nil) {printLog("Service Call: \nRequest for url: \(url)\nParameters: \(dicsParams!)")}
        else {printLog("Service Call: \nRequest for url: \(url)")}
        
        Alamofire.request(url, method: method, parameters: dicsParams, encoding:
            URLEncoding.default, headers: dictHeaders)
            
        .responseJSON { response in
            self.handleResponse(dataResponse: response, request: response.request!, completionHandler: completionHandler)
        }
        
        .responseString { response in
            self.handleResponse(dataResponse: response, request: response.request!, completionHandler: completionHandler)
        }
    }
    
    func requestMultipartFormDataWithImageAndVideo(_ url : String, dicsParams : [String: Any]?, dicsHeaders : [String: String]?, completionHandler:@escaping CompletionHandler) {
        
        if NetworkReachablity().isNetwork(){
            showAlertWithTitle(CommonConstants.AlertTitle, message: CommonConstants.noInternetMsg)
            completionHandler(nil,nil,nil)
            return
        }

        if (dicsParams != nil) {printLog("Service Call: \nRequest for url: \(url)\nParameters: \(dicsParams!)")}
        else {printLog("Service Call: \nRequest for url: \(url)")}

        var dictHeaders:[String:String]? = nil
//        if sharedUserHelper.sessionToken() != nil{
//            dictHeaders = ["Authorization":"Bearer \(sharedUserHelper.sessionToken()!)"];
//        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in dicsParams! {
                
                if value is NSString
                {
                    let dt = (value as! String).data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
            }
            for (key, value) in dicsParams! {
                
                if value is UIImage
                {
                    if let imageData = UIImageJPEGRepresentation(value as! UIImage, 0.5)
                    {
                        multipartFormData.append(imageData, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                        break
                    }
                }
            }
            print(multipartFormData)
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: dictHeaders) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.handleResponse(dataResponse: response, request: response.request!, completionHandler: completionHandler)
                }
            case .failure(let encodingError):
                debugPrint(encodingError)
                completionHandler(nil, nil, encodingError as NSError?)
            }

        }
    }
    
    func requestMultipartFormDataWithImageAndVideoForPut(_ url : String, dicsParams : [String: Any]?, dicsHeaders : [String: String]?, completionHandler:@escaping CompletionHandler) {
        
        if NetworkReachablity().isNetwork(){
            showAlertWithTitle(CommonConstants.AlertTitle, message: CommonConstants.noInternetMsg)
            completionHandler(nil,nil,nil)
            return
        }

        if (dicsParams != nil) {printLog("Service Call: \nRequest for url: \(url)\nParameters: \(dicsParams!)")}
        else {printLog("Service Call: \nRequest for url: \(url)")}
        
        var dictHeaders:[String:String]? = nil
//        if sharedUserHelper.sessionToken() != nil{
//            dictHeaders = ["Authorization":"Bearer \(sharedUserHelper.sessionToken()!)"];
//        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in dicsParams! {
                
                if value is NSString
                {
                    let dt = (value as! String).data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
            }
            for (key, value) in dicsParams! {
                
                if value is UIImage
                {
                    if let imageData = UIImageJPEGRepresentation(value as! UIImage, 0.5)
                    {
                        multipartFormData.append(imageData, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                        break
                    }
                }
            }
            print(multipartFormData)
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .put, headers: dictHeaders) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.handleResponse(dataResponse: response, request: response.request!, completionHandler: completionHandler)
                }
            case .failure(let encodingError):
                debugPrint(encodingError)
                completionHandler(nil, nil, encodingError as NSError?)
            }
            
        }
    }
    
    func handleResponse(dataResponse: Any, request:URLRequest, completionHandler:@escaping CompletionHandler) {
        
        if dataResponse is DataResponse<Any>{
            
            let response = dataResponse as! DataResponse<Any>
            printLog("Service Call:\nResponse for url: \((request.url?.description)!)\nResponse:\(dataResponse)")
            if (response.result.isSuccess) {
//                if response.response?.statusCode == 403 && response.result.value is NSDictionary{
//                    let dictResponse:NSDictionary? = response.result.value as? NSDictionary
//                    if dictResponse?.object(forKey: "message") as! String == "usernotexist"{
//
//                        let message = (dictResponse?.object(forKey: "message") as! String)
//                        let messageFont = [NSFontAttributeName: FontConstants.RobotoMedium13]
//                        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
//
//                        let alert = UIAlertController(title: CommonConstants.AlertTitle, message:message, preferredStyle: UIAlertControllerStyle.alert)
//
//                        alert.setValue(messageAttrString, forKey: "attributedMessage")
//
//                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                            UIAlertAction in
//                            appDelegate.switchToLoginScreen()
//                        }
//                        okAction.setValue(UIColor.black, forKey: "titleTextColor")
//                        alert.addAction(okAction)
//                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
//
//                    }
//                }
                if response.result.value is NSNull {
                    let editedResponse = ["message" : (response.result.error! as NSError).localizedDescription]
                    completionHandler(editedResponse as NSDictionary?, response.response?.statusCode, nil)
                } else if response.result.value is NSArray {
                    let arrResponse = response.result.value as! NSArray
                    let dictResponse:NSDictionary? = NSDictionary.init(dictionary: ["data" as NSCopying : arrResponse])
                    completionHandler(dictResponse, response.response?.statusCode, nil)
                } else if response.result.value is NSDictionary {
                    let dictResponse:NSDictionary? = response.result.value as! NSDictionary?
                    completionHandler(dictResponse,  response.response?.statusCode, nil)
                } else {
                    completionHandler(response.result.value as! NSDictionary?, response.response?.statusCode,response
                        .result.error as NSError?)
                }
                
            } else {
                let editedResponse = ["message" : (response.result.error! as NSError).localizedDescription]
                completionHandler(editedResponse as NSDictionary?, (response.result.error! as NSError).code, nil)
            }
        }else if dataResponse is DataResponse<String>{
            
            
        }
    }
}
