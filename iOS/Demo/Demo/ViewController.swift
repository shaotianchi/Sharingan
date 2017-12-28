//
//  ViewController.swift
//  Demo
//
//  Created by Shao Tianchi on 2017/2/15.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit
import SharinganPlayer
import SharinganRecorder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(_ sender: Any) {
        SRGPlayer.shared.playFromLocal()
//        let events = SRGRecorder.shared.lastRecord
//        guard events.count > 0 else {
//            return
//        }
//
//        SRGPlayer().play(event: events[0], events: events)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else {
            return
        }
        
        if SRGRecorder.shared.state == .idle {
            SRGRecorder.shared.start()
        } else if SRGRecorder.shared.state == .recoding {
            SRGRecorder.shared.pause()
        }
    }
}

