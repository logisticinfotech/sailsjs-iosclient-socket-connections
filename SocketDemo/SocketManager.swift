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

@objc protocol SocketDelegate : NSObjectProtocol{
    @objc optional func returnGetCurrentTripByUser(_ data:NSArray)
    @objc optional func returnSendRequestFromAppUser(_ data:NSArray)
    @objc optional func onNoDriverFound(_ data:NSArray)
    @objc optional func returnCancelCurrentRequest(_ data:NSArray)
    @objc optional func onSendAcceptRejectFromDriver(_ data:NSArray)
    @objc optional func returnCancelActiveTrip(_ data:NSArray)
    @objc optional func returnCancelTripBeforeStart(_ data:NSArray)
    @objc optional func onCancelTripToUSer(_ data:NSArray)
    @objc optional func onStartTripToUser(_ data:NSArray)
    @objc optional func onTripPaymentFailed(_ data:NSArray)
    @objc optional func returnPaypayCashFromUser(_ data:NSArray)
    @objc optional func onTripPaymentSuccessToUser(_ data:NSArray)
    @objc optional func onChangedDriverLocationToUserNew(_ data:NSArray)
    @objc optional func returnChangeDropLocationByUser(_ data:NSArray)
    @objc optional func onDropLocationChangedToUser(_ data:NSArray)
    @objc optional func onDriverArrivedAtPickUpLocationToUser(_ data:NSArray)
    @objc optional func changedDriverLocationJourneyDistanceToUser(_ data:NSArray)
}

@objc protocol CustomeDelegateForRequestingView : NSObjectProtocol
{
    @objc optional func checkCustomerRequestStatus()
}

@objc protocol emitGetCurrentTripByUserDelegate : NSObjectProtocol
{
    @objc optional func emitGetCurrentTripByUserClickDelegate()
}
@objc protocol userLoginDelegate : NSObjectProtocol
{
    @objc optional func userLoginClickDelegate()
}
@objc protocol emitSendRequestDelegate : NSObjectProtocol
{
    @objc optional func emitSendRequestClickDelegate()
}
@objc protocol emitCancelCurrentRequestDelegate : NSObjectProtocol
{
    @objc optional func emitCancelCurrentRequestClickDelegate()
}
@objc protocol emitUserDisconnectDelegate : NSObjectProtocol
{
    @objc optional func emitUserDisconnectClickDelegate()
}
@objc protocol emitCancelRequestDelegate : NSObjectProtocol
{
    @objc optional func emitCancelRequestClickDelegate()
}
@objc protocol emitCancelActiveTripDelegate : NSObjectProtocol
{
    @objc optional func emitCancelActiveTripClickDelegate()
}
@objc protocol emitPayByCaseDelegate : NSObjectProtocol
{
    @objc optional func emitPayByCaseClickDelegate()
}
@objc protocol emitChangeDropLocationDelegate : NSObjectProtocol
{
    @objc optional func emitChangeDropLocationClickDelegate()
}


class SocketManagerTest: NSObject {
    var objSocketDelegate:SocketDelegate?
    var objCustomDelegateForRequestingView : CustomeDelegateForRequestingView?
    var objEmitGetCurrentTripByUserDelegate : emitGetCurrentTripByUserDelegate?
    var objUserLoginDelegate : userLoginDelegate?
    var objEmitSendRequestDelegate:emitSendRequestDelegate?
    var objemitCancelCurrentRequestDelegate : emitCancelCurrentRequestDelegate?
    var objEmitUserDisconnectDelegate : emitUserDisconnectDelegate?
    var objEmitCancelRequestDelegate : emitCancelRequestDelegate?
    var objEmitCancelActiveTripDelegate : emitCancelActiveTripDelegate?
    var objEmitPayByCaseDelegate : emitPayByCaseDelegate?
    var objEmitChangeDropLocationDelegate : emitChangeDropLocationDelegate?

    static let sharedInstance = SocketManagerTest()
    var options:SocketIOClientConfiguration!
    var socket: SocketIOClient!
    var manager : SocketManager!
    override init() {
        super.init()
    }
    
    func establishConnection(){
        if self.closeConnection()
        {
            if options != nil {
                options = nil;
            }
            if manager != nil{
               _ = self.closeConnection()
                manager = nil
            }
            if socket != nil {
                socket = nil
            }
            options = [] as SocketIOClientConfiguration
//            options.insert(.connectParams(["__sails_io_sdk_version":"1.0.2"]))
            options.insert(.reconnectAttempts(1000))
            options.insert(.reconnectWait(3))
            options.insert(.log(true))
            options.insert(.compress)
            options.insert(.forceWebsockets(true))
            
            
            manager = SocketManager(socketURL: URL(string: "http://192.168.0.73:1337")!, config: options)
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
            
            self.socket.on("rides") { (data, ack) in
                print("User Group Event Listener Response: \(data)\(ack)")
            }
            socket.on(clientEvent:.connect) { (data, ack) in
                
                print("connect")
            }
            socket.connect()
            
        }
    }
    
    func establishConnectionReturn(_ completionHandler: @escaping (_ returndata:AnyObject) -> Void) {
        
        
    }
    
    func emitPost() -> Void {

        let dictParameters = [ "url": String("http://192.168.0.73:1337/v1/socket-testPost")]
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            print(data);
        }
    }
    
    func emitGet() -> Void {
        
        let dictParameters = [ "url": String("http://192.168.0.73:1337/v1/socket-testGet")]
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            print(data);
        }
    }

    func emitPut() -> Void {
        
        let dictParameters = [ "url": String("http://192.168.0.73:1337/v1/socket-testPut")]
        self.socket.emitWithAck("post", with: [dictParameters]).timingOut(after: 10) {data in
            
            print(data);
        }
    }

    func closeConnection()->Bool
    {
        if self.socket != nil
        {
            self.socket.off("rides")
            socket.disconnect()
            self.socket.removeAllHandlers()
        }
        return true
    }
}
