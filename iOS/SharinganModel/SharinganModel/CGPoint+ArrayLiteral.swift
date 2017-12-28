//
//  CGPoint+ArrayLiteral.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit

extension CGPoint: ExpressibleByArrayLiteral {
    public typealias Element = CGFloat
    public init(arrayLiteral elements: Element...) {
        self.init(x: elements[0], y: elements[1])
    }
}

