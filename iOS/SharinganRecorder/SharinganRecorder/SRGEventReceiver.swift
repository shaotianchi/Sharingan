//
//  SRGReceiver.swift
//  SharinganRecorder
//
//  Created by Shao Tianchi on 2017/9/20.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import Foundation

protocol SRGEventReceiver {
    func receive(event: UIEvent)
}
