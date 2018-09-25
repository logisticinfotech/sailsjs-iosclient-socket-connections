//
//  SocketManager.swift
//  KeyAppCustomer
//
//  Created by JaydeepC on 21/05/16.
//  Copyright © 2016 Bhavin. All rights reserved.
//

import UIKit
import SocketIO
//import SocketIOClientSwift

enum UserStatus:String
{
    case online, offline
}

@objc protocol SocketDelegate : NSObjectProtocol
{
    @objc optional func receivePrivateMessage(_ data:NSDictionary)
    @objc optional func receiveTypingSocket(_ data:NSDictionary)
    @objc optional func receiveUserStatusUpdateSocket(_ data:NSDictionary)
    @objc optional func receiveOnlineUserListSocket(_ data:NSDictionary)
}


class SocketManagerTest: NSObject
{
    var objSocketDelegate:SocketDelegate?
    
    static let sharedInstance = SocketManagerTest()
    var options:SocketIOClientConfiguration!
    var socket: SocketIOClient!
    var manager : SocketManager!
    
    override init()
    {
        super.init()
    }
    
    let serverurl = SocketDetails.BaseURL
    
    func establishConnection()
    {
        if self.closeConnection()
        {
            if options != nil
            {
                options = nil;
            }
            if manager != nil
            {
                _ = self.closeConnection()
                manager = nil
            }
            if socket != nil
            {
                socket = nil
            }
            options = [] as SocketIOClientConfiguration
            options.insert(.connectParams(["__sails_io_sdk_version":"1.0.2"]))
            options.insert(.reconnectAttempts(1000))
            options.insert(.reconnectWait(3))
            options.insert(.log(false))
            options.insert(.compress)
            options.insert(.forceWebsockets(true))
            
            
            manager = SocketManager(socketURL: URL(string: serverurl)!, config: options)
            socket = manager.defaultSocket
            
            self.socket.on("disconnect"){data, ack in
                print("Discounnect")
            }
            self.socket.on("reconnect"){data, ack in
                print("reconnect")
            }
            self.socket.on("reconnectAttempt"){data, ack in
                print("reconnectAttempt")
            }
            self.socket.on("error"){data, ack in
                print("error")
            }
            socket.on(clientEvent:.connect) { (data, ack) in
                
                printLog("socket connected")
            }
            self.addUserChatListnerEvents()
            socket.connect()
        }
    }
    
    func establishConnectionReturn(_ completionHandler: @escaping (_ returndata:AnyObject) -> Void) {
    }
    
    //# MARK: - Ride listener Methods
    //# MARK: -
    
    func addUserChatListnerEvents()
    {
        self.socket.on("user") { (data, ack) in
            print("User Event Listener Response: \(data)\(ack)")
            if (data[0] as! NSDictionary).object(forKey: "actions") as! String == "message"
            {
                
                //store message to global dict
                
                
                
                if (SocketManagerTest.sharedInstance.objSocketDelegate != nil && (SocketManagerTest.sharedInstance.objSocketDelegate?.responds(to: #selector(SocketManagerTest.sharedInstance.objSocketDelegate?.receivePrivateMessage(_:))))!)
                {
                    SocketManagerTest.sharedInstance.objSocketDelegate?.receivePrivateMessage!(data[0] as! NSDictionary)
                }
            }
            else if (data[0] as! NSDictionary).object(forKey: "actions") as! String == "typing"
            {
                
                if (SocketManagerTest.sharedInstance.objSocketDelegate != nil && (SocketManagerTest.sharedInstance.objSocketDelegate?.responds(to: #selector(SocketManagerTest.sharedInstance.objSocketDelegate?.receiveTypingSocket(_:))))!)
                {
                    SocketManagerTest.sharedInstance.objSocketDelegate?.receiveTypingSocket!(data[0] as! NSDictionary)
                }
            }
            else if (data[0] as! NSDictionary).object(forKey: "actions") as! String == "userstatusupdate"
            {
                if (SocketManagerTest.sharedInstance.objSocketDelegate != nil && (SocketManagerTest.sharedInstance.objSocketDelegate?.responds(to: #selector(SocketManagerTest.sharedInstance.objSocketDelegate?.receiveUserStatusUpdateSocket(_:))))!)
                {
                    SocketManagerTest.sharedInstance.objSocketDelegate?.receiveUserStatusUpdateSocket!(data[0] as! NSDictionary)
                }
            }
            else if (data[0] as! NSDictionary).object(forKey: "actions") as! String == "onlineuserlist"
            {
                if (SocketManagerTest.sharedInstance.objSocketDelegate != nil && (SocketManagerTest.sharedInstance.objSocketDelegate?.responds(to: #selector(SocketManagerTest.sharedInstance.objSocketDelegate?.receiveOnlineUserListSocket(_:))))!)
                {
                    SocketManagerTest.sharedInstance.objSocketDelegate?.receiveOnlineUserListSocket!(data[0] as! NSDictionary)
                }
            }
        }
    }
    
    func emitPost() -> Void
    {
        let dictParameters = [ "url": String(serverurl + "/v1/socket-testPost")]
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            print(data);
        }
    }
    
    func emitGet() -> Void
    {
        let dictParameters = [ "url": String( serverurl + "/v1/socket-testGet")]
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            print(data);
        }
    }
    
    func emitPut() -> Void
    {
        let dictParameters = [ "url": String( serverurl + "/v1/socket-testPut")]
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            print(data);
        }
    }
    
    //# MARK: - Socket Subscribe Method
    //# MARK: -
    
    func emitSendPrivateMessageSocketSubscribe(strMsg:String,userId:Int,toUserId:Int, completionHandler:@escaping (_ dictResponse:NSDictionary?) -> ())
    {
        let dictParameters = [ "url": SocketDetails.SendPrivateMessage,
                               "data": ["userid" : userId,"touserid" : toUserId,"msg":strMsg]] as [String : Any]
        printLog("Send Private Message Request: \(dictParameters)")
        
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            if data[0] is NSDictionary
            {
                if (data[0] as! NSDictionary).object(forKey: "body") is NSDictionary
                {
                    printLog("Send Private Message No Ack: \(data[0])")
                    let responseBody = (data[0] as! NSDictionary).object(forKey: "body") as! NSDictionary
                    completionHandler(responseBody)
                }
            }
        }
    }
    
    func emitPrivateMessageTypingSocketSubscribe(toUserId:Int, completionHandler:@escaping (_ dictResponse:NSDictionary?) -> ())
    {
        if appDelegate.currentUserId == nil
        {
            return
        }
        let dictParameters = [ "url": SocketDetails.PrivateMessageTyping,
                               "data": ["userid" : appDelegate.currentUserId!,"touserid" : toUserId]] as [String : Any]
        printLog("Private Message Typing Request: \(dictParameters)")
        
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            if data[0] is NSDictionary
            {
                printLog("Private Message Typing No Ack: \(data[0])")
                if (data[0] as! NSDictionary).object(forKey: "body") is NSDictionary{
                    let responseBody = (data[0] as! NSDictionary).object(forKey: "body") as! NSDictionary
                    completionHandler(responseBody)
                }
            }
        }
    }
    
    func emitChangeUserStatusSocketSubscribe(strStatus:String, completionHandler:@escaping (_ dictResponse:NSDictionary?) -> ())
    {
        if appDelegate.currentUserId == nil
        {
            return
        }
        let dictParameters = ["data": ["userid" : "\(appDelegate.currentUserId!)","userstatus" : strStatus],"url": SocketDetails.ChangeUserStatus] as [String : Any]
        
        printLog("Change User Status Request: \(dictParameters)")
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            if data[0] is NSDictionary
            {
                if (data[0] as! NSDictionary).object(forKey: "body") is NSDictionary
                {
                    printLog("Change User Status No Ack: \(data[0])")
                    let responseBody = (data[0] as! NSDictionary).object(forKey: "body") as! NSDictionary
                    completionHandler(responseBody)
                }
            }
        }
    }
    
    func closeConnection()->Bool
    {
        if self.socket != nil
        {
            printLog("socket disconnect")
            self.socket.off("user")
            socket.disconnect()
            self.socket.removeAllHandlers()
        }
        return true
    }
}
