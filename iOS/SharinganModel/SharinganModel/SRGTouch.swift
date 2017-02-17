//
//  SRGTouch.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit

public class SRGTouch: NSObject, NSCoding {
    public var point: CGPoint = .zero
    public var phase: UITouchPhase
    public var viewIdentifier: String = ""
    public var haveView: Bool = false
    public var deltPoint: CGPoint = .zero
    
    public init(touch: UITouch) {
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
    
    required public init?(coder aDecoder: NSCoder) {
        self.point = aDecoder.decodeCGPoint(forKey: "point")
        self.phase = UITouchPhase(rawValue: aDecoder.decodeInteger(forKey: "phase"))!
        self.viewIdentifier = aDecoder.decodeObject(forKey: "viewID") as! String
        self.haveView = aDecoder.decodeBool(forKey: "haveView")
        self.deltPoint = aDecoder.decodeCGPoint(forKey: "deltPoint")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(point, forKey: "point")
        aCoder.encode(phase.rawValue, forKey: "phase")
        aCoder.encode(viewIdentifier, forKey: "viewID")
        aCoder.encode(haveView, forKey:"haveView")
        aCoder.encode(deltPoint, forKey: "deltPoint")
    }
}
