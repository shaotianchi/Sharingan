//
//  SRGRecorderEvent.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit

public class SRGEvent: NSObject, NSCoding {
    public var touches: [SRGTouch] = []
    public var time: TimeInterval
    public var nextTime: TimeInterval = 0
    
    public init(event: UIEvent) {
        for touch in event.allTouches! {
            let iTouch = SRGTouch(touch: touch)
            touches.append(iTouch)
        }
        
        time = event.timestamp
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.touches = aDecoder.decodeObject(forKey: "touches") as! [SRGTouch]
        self.time = aDecoder.decodeDouble(forKey: "time")
        self.nextTime = aDecoder.decodeDouble(forKey: "nextTime")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(touches, forKey: "touches")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(nextTime, forKey: "nextTime")
    }
}
