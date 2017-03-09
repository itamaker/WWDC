//
//  URLSchemeHandler.swift
//  WWDC
//
//  Created by Guilherme Rambo on 29/05/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

import Foundation

private let _sharedInstance = URLSchemeHandler()

class URLSchemeHandler: NSObject {
    
    class func SharedHandler() -> URLSchemeHandler {
        return _sharedInstance
    }
    
    func register() {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(URLSchemeHandler.handleURLEvent(_:replyEvent:)), forEventClass: UInt32(kInternetEventClass), andEventID: UInt32(kAEGetURL))
    }
    
    func handleURLEvent(_ event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: UInt32(keyDirectObject))?.stringValue {
            if let url = URL(string: urlString) {
                if let host = url.host {
                    findAndOpenSession(host,url.path.replacingOccurrences(of: "/", with: "", options: .caseInsensitive, range: nil))
                }
            }
        }
    }
    
    fileprivate func findAndOpenSession(_ year: String, _ id: String) {
        let sessionKey = "#\(year)-\(id)"
        guard let session = WWDCDatabase.sharedDatabase.realm.object(ofType: Session.self, forPrimaryKey: sessionKey as AnyObject) else { return }
        
        // session has HD video
        if let url = session.hd_url {
            if VideoStore.SharedStore().hasVideo(url) {
                // HD video is available locally
                let url = VideoStore.SharedStore().localVideoAbsoluteURLString(url)
                launchVideo(session, url: url)
            } else {
                // HD video is not available locally
                launchVideo(session, url: url)
            }
        } else {
            // session has only SD video
            launchVideo(session, url: session.videoURL)
        }
    }
    
    fileprivate func launchVideo(_ session: Session, url: String) {
        let controller = VideoWindowController(session: session, videoURL: url)
        controller.showWindow(self)
    }
    
}
