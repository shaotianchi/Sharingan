//
//  main.swift
//  Demo
//
//  Created by Shao Tianchi on 2017/2/16.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit
import SharinganRecorder

UIApplicationMain(CommandLine.argc,
                  UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                    .bindMemory(
                        to: UnsafeMutablePointer<Int8>.self,
                        capacity: Int(CommandLine.argc)),
                  NSStringFromClass(SRGApplication.self),
                  NSStringFromClass(AppDelegate.self))
