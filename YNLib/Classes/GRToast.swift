//
//  GRToast.swift
//  Groubum
//
//  Created by 李锦心 on 15/8/25.
//  Copyright (c) 2015年 stoprain. All rights reserved.
//

import Foundation

public class GRToast {
    
    public static let TastyToast = GRToast()

    open var successColor = UIColor(hexString: "F8E71C")
    open var errorColor = UIColor(hexString: "#FD4C5F")
    fileprivate var notiView:UIView
    fileprivate var textLabel:UILabel
    fileprivate var showing:Bool = false
    
    init() {
        self.notiView = UIView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 0))
        self.notiView.isHidden = true
        self.notiView.backgroundColor = self.errorColor
        
        self.textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 29))
        self.textLabel.textColor = UIColor.white
        self.textLabel.textAlignment = NSTextAlignment.center
        self.textLabel.font = UIFont.systemFont(ofSize: 12)
        self.textLabel.alpha = 0
        self.notiView.addSubview(self.textLabel)
    }

    open func showError(_ text:String,target:UINavigationBar) {
        if self.showing {
            return
        }
        self.showing = true
        self.notiView.isHidden = false
        self.textLabel.text = text
        self.notiView.backgroundColor = self.errorColor
        let t = self.timeCompute(text)
        target.addSubview(self.notiView)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.notiView.setSizeByHeight(29)
            self.textLabel.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 0.3, delay: t, options: UIView.AnimationOptions(), animations: { () -> Void in
                    self.notiView.setSizeByHeight(0)
                    self.textLabel.alpha = 0
                    }, completion: { finished in
                        self.showing = false
                        self.notiView.isHidden = true
                        if let _ = self.notiView.superview {
                            self.notiView.removeFromSuperview()
                        }
                })
        })
    }
    
    open func showSuccess(_ text:String,target:UINavigationBar) {
        if self.showing {
            return
        }
        self.showing = true
        self.notiView.isHidden = false
        self.textLabel.text = text
        self.notiView.backgroundColor = self.successColor
        let t = self.timeCompute(text)
        target.addSubview(self.notiView)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.notiView.setSizeByHeight(29)
            self.textLabel.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 0.3, delay: t, options: UIView.AnimationOptions(), animations: { () -> Void in
                    self.notiView.setSizeByHeight(0)
                    self.textLabel.alpha = 0
                    }, completion: { finished in
                        self.showing = false
                        self.notiView.isHidden = true
                        if let _ = self.notiView.superview {
                            self.notiView.removeFromSuperview()
                        }
                })
        })
    }
    
    fileprivate func timeCompute(_ text:String) -> Double {
        let n:Double = Double(StringTerminator.countString(text))
        let t:Double = 1.0 + 0.07 * n
        return t
    }
}
