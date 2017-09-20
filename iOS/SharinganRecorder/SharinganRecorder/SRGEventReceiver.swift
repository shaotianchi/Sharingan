//
//  SRGReceiver.swift
//  SharinganRecorder
//
//  Created by Shao Tianchi on 2017/9/20.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import Foundation

public protocol SRGEventReceiver {
    var identifier: String { get set }
    func receive(event: UIEvent)
    func recorderStop()
    func recorderStart()
}
