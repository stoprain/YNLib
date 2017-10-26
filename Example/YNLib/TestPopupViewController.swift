//
//  TestPopupViewController.swift
//  YNLib
//
//  Created by stoprain on 13/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import YNLib

class TestPopupViewController: CustomPopupViewController {
    
    private var container = UIView()

    override func prepareCustomView() {
        super.prepareCustomView()
        
        UIView.animate(withDuration: self.inAnimationDuration) {
            self.container.alpha = 1
        }
    }
    
    override func cleanUpCustomView() {
        super.cleanUpCustomView()
        
        UIView.animate(withDuration: self.inAnimationDuration) {
            self.container.alpha = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.container.backgroundColor = UIColor.red
        self.container.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.container.alpha = 0
        self.view.addSubview(container)
        
        let l = CopyableLabel()
        l.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        l.backgroundColor = UIColor.blue
        l.text = "fadljfkl asdf"
        self.container.addSubview(l)
    }

}
