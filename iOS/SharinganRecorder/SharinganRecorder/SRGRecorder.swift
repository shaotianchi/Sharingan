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
    
    var receivers: [SRGEventReceiver] = []
    
    public private(set) var state = SRGRecorderState.idle
    
    override init() {
        super.init()
    }
    
    public func start() {
        state = .recoding
        receivers.forEach { $0.recorderStart() }
    }
    
    public func pause() {
        state = .pausing
        receivers.forEach { $0.recorderStop() }
    }
    
    public func add(receiver: SRGEventReceiver) {
        receivers.append(receiver)
    }
    
    public func remove(receiver identifier: String) {
        if let index = receivers.index(where: { $0.identifier == identifier}) {
            receivers.remove(at: index)
        }
    }
}

public extension SRGRecorder {
    func record(event: UIEvent) {
        
        receivers.forEach {
            $0.receive(event: event)
        }
    }
}
