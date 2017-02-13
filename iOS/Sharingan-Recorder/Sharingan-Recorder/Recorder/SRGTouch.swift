//
//  SRGTouch.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit

class SRGTouch: NSObject, NSCoding {
    var point: CGPoint = .zero
    var phase: UITouchPhase
    var viewIdentifier: String = ""
    var haveView: Bool = false
    var deltPoint: CGPoint = .zero
    
    init(touch: UITouch) {
        if let view = touch.view {
            self.point = touch.location(in: view)
            self.viewIdentifier = view.identifier
            self.haveView = true
            let previousPoint = touch.previousLocation(in: view)
            self.deltPoint = [self.point.x - previousPoint.x, self.point.y - previousPoint.y]
        } else if let window = touch.window {
            self.point = touch.location(in: window)
            let previousPoint = touch.previousLocation(in: window)
            self.deltPoint = [self.point.x - previousPoint.x, self.point.y - previousPoint.y]
            self.viewIdentifier = window.identifier
            self.haveView = false
        } else {
            assert(true, "\(touch)")
        }
        
        self.phase = touch.phase
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.point = aDecoder.decodeCGPoint(forKey: "point")
        self.phase = UITouchPhase(rawValue: aDecoder.decodeInteger(forKey: "phase"))!
        self.viewIdentifier = aDecoder.decodeObject(forKey: "viewID") as! String
        self.haveView = aDecoder.decodeBool(forKey: "haveView")
    }
    
    internal func encode(with aCoder: NSCoder) {
        aCoder.encode(point, forKey: "point")
        aCoder.encode(phase.rawValue, forKey: "phase")
        aCoder.encode(viewIdentifier, forKey: "viewID")
        aCoder.encode(haveView, forKey:"haveView")
    }
}
