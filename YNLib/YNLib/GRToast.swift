//
//  GRToast.swift
//  Groubum
//
//  Created by 李锦心 on 15/8/25.
//  Copyright (c) 2015年 yunio. All rights reserved.
//

import Foundation
import UIKit

private let sharedInstance = GRToast()

class GRToast {
    
    class var TastyToast: GRToast {
        return sharedInstance
    }
    
    var successColor = UIColor(hexString: "F8E71C")
    var errorColor = UIColor(hexString: "#FD4C5F")
    private var notiView:UIView
    private var textLabel:UILabel
    private var showing:Bool = false
    
    init() {
        self.notiView = UIView(frame: CGRect(x: 0, y: 44, width: UIScreen.mainScreen().bounds.width, height: 0))
        self.notiView.hidden = true
        self.notiView.backgroundColor = UIColor(hexString: "#FD4C5F")
        
        self.textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 29))
        self.textLabel.textColor = UIColor.whiteColor()
        self.textLabel.textAlignment = NSTextAlignment.Center
        self.textLabel.font = UIFont.systemFontOfSize(12)
        self.textLabel.alpha = 0
        self.notiView.addSubview(self.textLabel)
    }

    func showError(text:String,target:UINavigationBar) {
        if self.showing {
            return
        }
        self.showing = true
        self.notiView.hidden = false
        self.textLabel.text = text
        self.notiView.backgroundColor = UIColor(hexString: "#FD4C5F")
        let t = self.timeCompute(text)
        target.addSubview(self.notiView)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.notiView.setSizeByHeight(29)
            self.textLabel.alpha = 1
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: t, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.notiView.setSizeByHeight(0)
                    self.textLabel.alpha = 0
                    }, completion: { finished in
                        self.showing = false
                        self.notiView.hidden = true
                        if let _ = self.notiView.superview {
                            self.notiView.removeFromSuperview()
                        }
                })
        })
    }
    
    func showSuccess(text:String,target:UINavigationBar) {
        if self.showing {
            return
        }
        self.showing = true
        self.notiView.hidden = false
        self.textLabel.text = text
        self.notiView.backgroundColor = UIColor(hexString: "F8E71C")
        let t = self.timeCompute(text)
        target.addSubview(self.notiView)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.notiView.setSizeByHeight(29)
            self.textLabel.alpha = 1
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: t, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.notiView.setSizeByHeight(0)
                    self.textLabel.alpha = 0
                    }, completion: { finished in
                        self.showing = false
                        self.notiView.hidden = true
                        if let _ = self.notiView.superview {
                            self.notiView.removeFromSuperview()
                        }
                })
        })
    }
    
    private func timeCompute(text:String) -> Double {
        let n:Double = Double(StringTerminator.countString(text))
        let t:Double = 1.0 + 0.07 * n
        return t
    }
}
