//
//  TranscriptAdapter.swift
//  WWDC
//
//  Created by Guilherme Rambo on 07/06/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Foundation
import SwiftyJSON

class TranscriptLineAdapter: JSONAdapter {
    
    typealias ModelType = TranscriptLine
    
    static func adapt(_ json: JSON) -> ModelType {
        let line = TranscriptLine()
        
        line.timecode = json["timecode"].doubleValue
        line.text = json["annotation"].stringValue
        
        return line
    }
    
}

class TranscriptAdapter: JSONAdapter {
    
    typealias ModelType = Transcript
    
    static func adapt(_ json: JSON) -> ModelType {
        let transcript = Transcript()
        
        transcript.fullText = json["transcript"].stringValue
        
        if let annotations = json["annotations"].arrayObject as? [String], let timecodes = json["timecodes"].arrayObject as? [Double] {
            let transcriptData = annotations.map { annotations.index(of: $0)! >= timecodes.count ? JSON.null : JSON(["annotation": $0, "timecode": timecodes[annotations.index(of: $0)!]]) }.filter({ $0 != nil }).map({$0!})
            
            transcriptData.map(TranscriptLineAdapter.adapt).forEach { line in
                line.transcript = transcript
                transcript.lines.append(line)
            }
        }
        
        return transcript
    }
    
}
