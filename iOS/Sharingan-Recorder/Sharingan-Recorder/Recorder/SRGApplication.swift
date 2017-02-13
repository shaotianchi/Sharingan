//
//  SRGApplication.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit

class SRGApplication: UIApplication {
    override func sendEvent(_ event: UIEvent) {
        print(event)
        if SRGRecorder.shared.state == .recoding {
            SRGRecorder.shared.record(event: event)
        }
        
        super.sendEvent(event)
    }
}
