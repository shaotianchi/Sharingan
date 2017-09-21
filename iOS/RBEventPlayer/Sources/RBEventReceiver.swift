//
//  RBEventReceiver.swift
//  RBEventPlayer
//
//  Created by Shao Tianchi on 2017/9/20.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import Foundation
import Sharingan

class RBEventReceiver: SRGEventReceiver {
    
    private let savePath = "\(NSTemporaryDirectory())com.rainbow.SRGRecoder"
    
    var events: [SRGEvent] = []
    
    var identifier: String = "RBEventReceiver"
    
    func recorderStop() {
        if !FileManager.default.fileExists(atPath: savePath) {
            try? FileManager.default.createDirectory(atPath: savePath, withIntermediateDirectories: false, attributes: nil)
        }
        NSKeyedArchiver.archiveRootObject(events, toFile: savePath + "/recoder")
    }
    
    var cachedEvents: [SRGEvent] {
        guard FileManager.default.fileExists(atPath: savePath + "/recoder"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: savePath + "/recoder")),
            let events = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SRGEvent],
            events.count > 0 else {
                return []
        }

        return events
    }
    
    func recorderStart() {
        
    }
    
    func receive(event: UIEvent) {
        let iEvent = SRGEvent(event: event)

        if let preEvent = events.last {
            preEvent.nextTime = iEvent.time - preEvent.time
        }
        events.append(iEvent)
    }
}
