//
//  ViewController.swift
//  YNLib
//
//  Created by stoprain on 06/27/2017.
//  Copyright (c) 2017 stoprain. All rights reserved.
//

import UIKit
import YNLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { 
            let c = TestPopupViewController()
            self.present(c, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

