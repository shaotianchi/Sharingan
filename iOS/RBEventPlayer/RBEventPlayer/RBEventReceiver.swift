//
//  RBEventReceiver.swift
//  RBEventPlayer
//
//  Created by Shao Tianchi on 2017/9/20.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import Foundation
import Sharingan

struct RBEventReceiver: SRGEventReceiver {
    var identifier: String = "RBEventReceiver"
    
    func recorderStop() {
        
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
