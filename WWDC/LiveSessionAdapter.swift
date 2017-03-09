//
//  LiveSessionAdapter.swift
//  WWDC
//
//  Created by Guilherme Rambo on 07/06/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Foundation
import SwiftyJSON

class LiveSessionAdapter: JSONAdapter {
    
    typealias ModelType = LiveSession
    
    fileprivate struct Constants {
        static let dateTimezone = "GMT"
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'ZZZZ"
        static let dateFormatForNewSessions = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    }
    
    fileprivate struct Keys {
        static let id = "id"
        static let title = "title"
        static let description = "description"
        static let stream = "stream"
        static let stream2 = "stream_elcapitan"
        static let startsAt = "starts_at"
        static let isLiveRightNow = "isLiveRightNow"
    }
    
    static func adaptSpecial(_ json: JSON) -> ModelType {
        let session = LiveSession()
        
        session.id = json[Keys.id].intValue
        
        if let title = json[Keys.title].string {
            session.title = title
        } else {
            session.title = ""
        }
        
        if let description = json[Keys.description].string {
            session.summary = description
        } else {
            session.summary = ""
        }
        
        if let streamURL = json[Keys.stream].string {
            session.streamURL = URL(string: streamURL)
        }
        
        session.isLiveRightNow = json[Keys.isLiveRightNow].boolValue
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        if let startsAtString = json[Keys.startsAt].string {
            let startsAtWithZone = startsAtString + Constants.dateTimezone
            session.startsAt = formatter.date(from: startsAtWithZone)
        }
        
        return session
    }
    
    static func adapt(_ json: JSON) -> ModelType {
        let session = LiveSession()
        
        session.id = json[Keys.id].intValue
        
        if let title = json[Keys.title].string {
            session.title = title
        } else {
            session.title = ""
        }
        
        if let description = json[Keys.description].string {
            session.summary = description
        } else {
            session.summary = ""
        }
        
        if let streamURL = json["url"].string {
            session.streamURL = URL(string: streamURL)
        }
        
        session.isLiveRightNow = json[Keys.isLiveRightNow].boolValue
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormatForNewSessions
        
        if let startsAtString = json["start_date"].string {
            session.startsAt = formatter.date(from: startsAtString)
        }
        if let endsAtString = json["end_date"].string {
            session.endsAt = formatter.date(from: endsAtString)
        }
        
        return session
    }
    
}
