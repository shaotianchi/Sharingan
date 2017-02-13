//
//  SRGPlayer.swift
//  Sharingan-Player
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit
import SharinganModel

public class SRGPlayer: NSObject {
    var holdingViews:[String: UIView] = [:]
    
    func play(event: SRGEvent, events: [SRGEvent]) {
        let touches = event.touches
        var uitouches: [UITouch] = []
        for touch in touches {
            let viewInfo = UIView.getViewByIdentifier(identifier: touch.viewIdentifier)
            let view = viewInfo.0!
            if let transformView = viewInfo.1 {
                if touch.phase == .began {
                    holdingViews[transformView.identifier] = transformView
                } else if touch.phase == .moved {
                    if holdingViews.keys.contains(transformView.identifier) {
                        holdingViews[transformView.identifier] = nil
                    }
                    
                    if transformView is UIScrollView {
                        let scrollView = transformView as! UIScrollView
                        scrollView.setContentOffset([0, scrollView.contentOffset.y + touch.deltPoint.y], animated: false)
                    }
                } else if touch.phase == .ended {
                    if !holdingViews.keys.contains(transformView.identifier) {
                        continue
                    }
                    
                    if transformView is UITableView {
                        let tableView = (transformView as! UITableView)
                        if let indexPath = tableView.indexPathForRow(at: transformView.convert(touch.point, from: view)) {
                            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                            tableView.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
                        }
                    } else if transformView is UICollectionView {
                        let collectionView = (transformView as! UICollectionView)
                        if let indexPath = collectionView.indexPathForItem(at: transformView.convert(touch.point, from: view)) {
                            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
                            collectionView.delegate!.collectionView!(collectionView, didSelectItemAt: indexPath)
                        }
                    }
                }
            } else {
                var uitouch: UITouch
                if touch.haveView {
                    uitouch = UITouch(at: touch.point, in: view)!
                } else {
                    uitouch = UITouch(at: touch.point, in: view as! UIWindow, emptyTouchView: true)!
                }
                uitouch.setPhaseAndUpdateTimestamp(touch.phase)
                uitouches.append(uitouch)
            }
        }
        
        let uievent = UIApplication.shared._touchesEvent()!
        uievent._clearTouches()
        uievent.srg_setEvent(withTouches: uitouches)
        uitouches.forEach { (touch) in
            uievent._add(touch, forDelayedDelivery: false)
        }
        UIApplication.shared.sendEvent(uievent)
        
        
        guard let index = events.index(of: event),
            index != events.count - 1 else {
                return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + event.nextTime) {
            self.play(event: events[index + 1], events: events)
        }
    }
}