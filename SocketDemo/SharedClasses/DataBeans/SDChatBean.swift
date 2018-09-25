//
//  SDChatBean.swift
//  SocketDemo
//
//  Created by Krishna on 22/09/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SDChatBean: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let mediasize = "mediasize"
        static let id = "id"
        static let mediatype = "mediatype"
        static let imgwidth = "imgwidth"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let fromuser = "fromuser"
        static let mediadata = "mediadata"
        static let messagestatus = "messagestatus"
        static let imgheight = "imgheight"
        static let chattype = "chattype"
        static let touser = "touser"
    }
    
    // MARK: Properties
    public var mediasize: Int?
    public var id: Int?
    public var mediatype: String?
    public var imgwidth: Int?
    public var createdAt: Int?
    public var updatedAt: Int?
    public var fromuser: Int?
    public var mediadata: String?
    public var messagestatus: String?
    public var imgheight: Int?
    public var chattype: String?
    public var touser: Int?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        mediasize = json[SerializationKeys.mediasize].int
        id = json[SerializationKeys.id].int
        mediatype = json[SerializationKeys.mediatype].string
        imgwidth = json[SerializationKeys.imgwidth].int
        createdAt = json[SerializationKeys.createdAt].int
        updatedAt = json[SerializationKeys.updatedAt].int
        fromuser = json[SerializationKeys.fromuser].int
        mediadata = json[SerializationKeys.mediadata].string
        messagestatus = json[SerializationKeys.messagestatus].string
        imgheight = json[SerializationKeys.imgheight].int
        chattype = json[SerializationKeys.chattype].string
        touser = json[SerializationKeys.touser].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = mediasize { dictionary[SerializationKeys.mediasize] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = mediatype { dictionary[SerializationKeys.mediatype] = value }
        if let value = imgwidth { dictionary[SerializationKeys.imgwidth] = value }
        if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
        if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
        if let value = fromuser { dictionary[SerializationKeys.fromuser] = value }
        if let value = mediadata { dictionary[SerializationKeys.mediadata] = value }
        if let value = messagestatus { dictionary[SerializationKeys.messagestatus] = value }
        if let value = imgheight { dictionary[SerializationKeys.imgheight] = value }
        if let value = chattype { dictionary[SerializationKeys.chattype] = value }
        if let value = touser { dictionary[SerializationKeys.touser] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.mediasize = aDecoder.decodeObject(forKey: SerializationKeys.mediasize) as? Int
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
        self.mediatype = aDecoder.decodeObject(forKey: SerializationKeys.mediatype) as? String
        self.imgwidth = aDecoder.decodeObject(forKey: SerializationKeys.imgwidth) as? Int
        self.createdAt = aDecoder.decodeObject(forKey: SerializationKeys.createdAt) as? Int
        self.updatedAt = aDecoder.decodeObject(forKey: SerializationKeys.updatedAt) as? Int
        self.fromuser = aDecoder.decodeObject(forKey: SerializationKeys.fromuser) as? Int
        self.mediadata = aDecoder.decodeObject(forKey: SerializationKeys.mediadata) as? String
        self.messagestatus = aDecoder.decodeObject(forKey: SerializationKeys.messagestatus) as? String
        self.imgheight = aDecoder.decodeObject(forKey: SerializationKeys.imgheight) as? Int
        self.chattype = aDecoder.decodeObject(forKey: SerializationKeys.chattype) as? String
        self.touser = aDecoder.decodeObject(forKey: SerializationKeys.touser) as? Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(mediasize, forKey: SerializationKeys.mediasize)
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(mediatype, forKey: SerializationKeys.mediatype)
        aCoder.encode(imgwidth, forKey: SerializationKeys.imgwidth)
        aCoder.encode(createdAt, forKey: SerializationKeys.createdAt)
        aCoder.encode(updatedAt, forKey: SerializationKeys.updatedAt)
        aCoder.encode(fromuser, forKey: SerializationKeys.fromuser)
        aCoder.encode(mediadata, forKey: SerializationKeys.mediadata)
        aCoder.encode(messagestatus, forKey: SerializationKeys.messagestatus)
        aCoder.encode(imgheight, forKey: SerializationKeys.imgheight)
        aCoder.encode(chattype, forKey: SerializationKeys.chattype)
        aCoder.encode(touser, forKey: SerializationKeys.touser)
    }
    
}

