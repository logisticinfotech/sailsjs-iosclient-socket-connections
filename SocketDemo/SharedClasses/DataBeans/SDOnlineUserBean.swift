//
//  Data.swift
//
//  Created by Khyati on 28/08/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SDOnlineUserBean: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let updatedAt = "updatedAt"
    static let socketid = "socketid"
    static let id = "id"
    static let userstatus = "userstatus"
    static let username = "username"
    static let createdAt = "createdAt"
  }

  // MARK: Properties
  public var updatedAt: Int?
  public var socketid: String?
  public var id: Int?
  public var userstatus: String?
  public var username: String?
  public var createdAt: Int?

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
    updatedAt = json[SerializationKeys.updatedAt].int
    socketid = json[SerializationKeys.socketid].string
    id = json[SerializationKeys.id].int
    userstatus = json[SerializationKeys.userstatus].string
    username = json[SerializationKeys.username].string
    createdAt = json[SerializationKeys.createdAt].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = updatedAt { dictionary[SerializationKeys.updatedAt] = value }
    if let value = socketid { dictionary[SerializationKeys.socketid] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = userstatus { dictionary[SerializationKeys.userstatus] = value }
    if let value = username { dictionary[SerializationKeys.username] = value }
    if let value = createdAt { dictionary[SerializationKeys.createdAt] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.updatedAt = aDecoder.decodeObject(forKey: SerializationKeys.updatedAt) as? Int
    self.socketid = aDecoder.decodeObject(forKey: SerializationKeys.socketid) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.userstatus = aDecoder.decodeObject(forKey: SerializationKeys.userstatus) as? String
    self.username = aDecoder.decodeObject(forKey: SerializationKeys.username) as? String
    self.createdAt = aDecoder.decodeObject(forKey: SerializationKeys.createdAt) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(updatedAt, forKey: SerializationKeys.updatedAt)
    aCoder.encode(socketid, forKey: SerializationKeys.socketid)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(userstatus, forKey: SerializationKeys.userstatus)
    aCoder.encode(username, forKey: SerializationKeys.username)
    aCoder.encode(createdAt, forKey: SerializationKeys.createdAt)
  }

}
