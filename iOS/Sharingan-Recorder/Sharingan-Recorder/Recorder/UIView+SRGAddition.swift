//
//  UIView+SRGAddition.swift
//  Sharingan-Recorder
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

import UIKit
import WebKit

public let UIWindowIdentifier = "UIWindow"

class ViewIdentifierCache: NSObject {
    public static let instance = ViewIdentifierCache()
    
    var cache: NSCache<UIView, AnyObject> = NSCache<UIView, AnyObject>()
}

extension UIView {
    var identifier: String {
        if let cache = ViewIdentifierCache.instance.cache.object(forKey: self) {
            return cache as! String
        }
        
        var identifier: String
        if self is UIWindow {
            identifier = UIWindowIdentifier
        } else {
            identifier = superIdentifier(view: self, identifier: "")
        }
        
        ViewIdentifierCache.instance.cache.setObject(identifier as AnyObject, forKey: self)
        print("\(self) \(identifier)")
        return identifier
    }
    
    func superIdentifier(view: UIView, identifier: String) -> String {
        var identifier = identifier
        if let superView = view.superview {
            
            let index = superView.subviews.index(of: view)!
            
            if superView is UIWindow {
                return "\(UIWindowIdentifier).\(index)\(identifier)"
            }
            
            identifier = ".\(index)" + identifier
            return superIdentifier(view: superView, identifier: identifier)
        } else {
            if let controller = self.traverseResponderChainForUIViewController() {
                identifier = "\(NSStringFromClass(controller.classForCoder))" + identifier
            }
            return identifier
        }
    }
    
    func traverseResponderChainForUIViewController() -> UIViewController? {
        guard let nextResponse = self.next else {
            return nil
        }
        
        if nextResponse is UIViewController {
            return nextResponse as? UIViewController
        } else if nextResponse is UIView {
            return (nextResponse as! UIView).traverseResponderChainForUIViewController()
        } else {
            return nil
        }
    }
    
    class func getViewByIdentifier(identifier: String) -> (UIView?, UIView?) {
        let indexs = identifier.components(separatedBy: ".")
        guard indexs.count > 1 else {
            if identifier == UIWindowIdentifier {
                return (UIApplication.shared.keyWindow, nil)
            }
            return (nil, nil)
        }
        
        let begin = indexs.first!
        if begin == UIWindowIdentifier {
            var transformView: UIView?
            if let window = UIApplication.shared.keyWindow {
                var view: UIView? = window
                for index in indexs[1...indexs.count - 1] {
                    let i = Int(index)!
                    if i >= view!.subviews.count {
                        view = nil
                        break
                    }
                    let nextView = view!.subviews[i]
                    if (nextView is UIScrollView || nextView is UITableView || nextView is UICollectionView || nextView is UIWebView || nextView is WKWebView) && transformView == nil {
                        transformView = nextView
                    }
                    
                    view = view!.subviews[i]
                }
                return (view, transformView)
            } else {
                return (nil, transformView)
            }
        } else { // Controller
            return (nil, nil)
        }
    }
}
