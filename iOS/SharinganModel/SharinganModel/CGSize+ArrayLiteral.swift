//
//  CGSize+ArrayLiteral.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit

extension CGSize: ExpressibleByArrayLiteral {
    public typealias Element = CGFloat
    public init(arrayLiteral elements: Element...) {
        self.init(width: elements[0], height: elements[1])
    }
}

