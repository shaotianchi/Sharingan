//
//  SRGApplication.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit

public class SRGApplication: UIApplication {
    override public func sendEvent(_ event: UIEvent) {
        if SRGRecorder.shared.state == .recoding && NSStringFromClass(event.classForCoder) == "UITouchesEvent" {
            SRGRecorder.shared.record(event: event)
        }
        
        super.sendEvent(event)
    }
}
