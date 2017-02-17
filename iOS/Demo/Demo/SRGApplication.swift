//
//  SRGApplication.swift
//  Demo
//
//  Created by Shao Tianchi on 2017/2/16.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit
import SharinganRecorder

class SRGApplication: UIApplication {
    override func sendEvent(_ event: UIEvent) {
        if SRGRecorder.shared.state == .recoding && NSStringFromClass(event.classForCoder) == "UITouchesEvent" {
            SRGRecorder.shared.record(event: event)
            print(event)
        }
        
        super.sendEvent(event)
    }
}
