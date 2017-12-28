//
//  SRGPlayerEventReceiver.swift
//  SharinganPlayer
//
//  Created by EscapedDog on 2017/12/28.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import Foundation
import SharinganRecorder

public class SRGPlayerEventReceiver: SRGEventReceiver {
    
    public init() {
        
    }
    
    public var identifier: String = "com.rainbow.SRGPlayer"
    private let savePath = "\(NSTemporaryDirectory())com.rainbow.SRGPlayer"
    
    var events = [SRGEvent]()
    
    public func receive(event: UIEvent) {
        let iEvent = SRGEvent(event: event)
        
        if let preEvent = events.last {
            preEvent.nextTime = iEvent.time - preEvent.time
        }
        events.append(iEvent)
    }
    
    public func recorderStop() {
        if !FileManager.default.fileExists(atPath: savePath) {
            try? FileManager.default.createDirectory(atPath: savePath, withIntermediateDirectories: false, attributes: nil)
        }
        NSKeyedArchiver.archiveRootObject(events, toFile: savePath + "/player_events")
    }
    
    public func recorderStart() {
        print("已经开始录制")
    }
}

