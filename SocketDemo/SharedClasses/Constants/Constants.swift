//
//  Constants.swift
//  SocketDemo
//
//  Created by Khyati on 28/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let sharedAFUtility = AFUtility.sharedInstance

////////////////////////////////////////////
//////////////// API Struct ////////////////
////////////////////////////////////////////
struct APIDetails {
    
    // Base URL
    private struct Domains {
        static let Localkhyati = "http://192.168.0.5:1337" // khyati 1337
        static let LocalNilesh = "http://192.168.0.8:1337" // khyati 1337
        static let LocalAnkur = "http://192.168.0.7:1338" // ankur 1338
    }
    
    // End Points
    private  struct EndPoints {
        static let kCreateUser = "/user"
        static let kGetOnlineUserList = "/onlineuser/"
        static let kGetChatHistory = "/chat/history"
    }
    private static let Domain = Domains.LocalNilesh// Use this to set Local or Live
    
    // Final URLs
    static let BaseURL = Domain
    static let CreateUser = Domain + EndPoints.kCreateUser
    static let GetOnlineUserList = Domain + EndPoints.kGetOnlineUserList
    static let GetChatHistory = Domain + EndPoints.kGetChatHistory
}

////////////////////////////////////////////
////////////// Socket Struct ///////////////
////////////////////////////////////////////

struct SocketDetails {
    
    // Base URL
    static let BaseURL = APIDetails.BaseURL
    
    // End Points
    private  struct EndPoints {
        static let kSendPrivateMessage = "/chat/privatemessage"
        static let kChangeUserStatus = "/updateuserstatus"
        static let kPrivateMessageTyping = "/chat/usertyping"
    }
    private static let Domain = BaseURL// Use this to set Local or Live
    
    // Final URLs
    static let SendPrivateMessage = Domain + EndPoints.kSendPrivateMessage
    static let ChangeUserStatus = Domain + EndPoints.kChangeUserStatus
    static let PrivateMessageTyping = Domain + EndPoints.kPrivateMessageTyping
}
// common constant
struct CommonConstants {
    static let noInternetMsg = "No Internet Connection"
    static let AlertTitle = "Alert"
}

// color constant
struct ColorConstants {
    static let TableBorderColor = UIColor(red:233/255.0, green:233/255.0, blue:233/255.0, alpha: 1)
}

//storyboard constant
struct StoryBoards {
    static let SDCreateUserSB = UIStoryboard(name: "SDCreateUserSB", bundle: nil)
    static let SDUserListSB = UIStoryboard(name: "SDUserListSB", bundle: nil)
    static let SDChatSB = UIStoryboard(name: "SDChatSB", bundle: nil)
}
