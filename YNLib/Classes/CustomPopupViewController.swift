//
//  CustomPopupViewController.swift
//  TwoTripleThree
//
//  Created by stoprain on 11/13/15.
//  Copyright © 2015 yunio. All rights reserved.
//

import UIKit

open class CustomPopupViewController: UIViewController {

    public var inAnimationDuration = 0.3
    public var outAnimationDuration = 0.2
    private var first = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        if first {
            self.first = false
            self.view.isUserInteractionEnabled = false
            self.view.backgroundColor = UIColor.clear
            UIView.animate(withDuration: self.inAnimationDuration, animations: { () -> Void in
                self.view.backgroundColor = UIColor(hexString: "#64000000")
                }, completion: { _ in
                    self.view.isUserInteractionEnabled = true
            })
            self.prepareCustomView()
        }
    }
    
    open func prepareCustomView() {
        
    }
    
    open func cleanUpCustomView() {
        
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: self.outAnimationDuration, animations: { () -> Void in
            self.view.backgroundColor = UIColor.clear
            }, completion: { (complete) -> Void in
                super.dismiss(animated: false) { () -> Void in
                    if let c = completion {
                        c()
                    }
                }
        })
        self.cleanUpCustomView()

    }

}
