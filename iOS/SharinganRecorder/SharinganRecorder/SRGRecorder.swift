//
//  SRGRecorder.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit
import WebKit

public enum SRGRecorderState {
    case idle
    case pausing
    case recoding
}

public class SRGRecorder: NSObject {
    
    public static let shared = SRGRecorder()
    
    fileprivate let savePath = "\(NSTemporaryDirectory())com.rainbow.SRGRecoder"
    
    public var ignoreIdentifiers:[String] = []
    
    public var state = SRGRecorderState.idle
    
    fileprivate var events: [SRGEvent] = []
    
    override init() {
        super.init()
    }
    
    public func start() {
        state = .recoding
    }
    
    public func pause() {
        state = .pausing
    }
    
    public func stopAndSave() {
        state = .idle
        if !FileManager.default.fileExists(atPath: savePath) {
            try? FileManager.default.createDirectory(atPath: savePath, withIntermediateDirectories: false, attributes: nil)
        }
        NSKeyedArchiver.archiveRootObject(events, toFile: savePath + "/recoder")
    }
    
    public var lastRecord:[SRGEvent] {
        guard FileManager.default.fileExists(atPath: savePath + "/recoder"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: savePath + "/recoder")) else {
                return []
        }
        
        print("=== start play events ===")
        guard let events = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SRGEvent],
            events.count > 0 else {
                return []
        }
        
        return events
    }
}

public extension SRGRecorder {
    func record(event: UIEvent) {
        let iEvent = SRGEvent(event: event)
        
        if let preEvent = events.last {
            preEvent.nextTime = iEvent.time - preEvent.time
        }
        events.append(iEvent)
    }
}
