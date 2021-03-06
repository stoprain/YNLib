//
//  WebViewController.swift
//  yourdoctor
//
//  Created by stoprain on 28/02/2017.
//  Copyright © 2017 heartsquare. All rights reserved.
//

import UIKit
import WebKit

@objc
open class WebViewController: UIViewController, WKNavigationDelegate {
    
    open lazy var webView: WKWebView = {
        return self.setupWebView()
    }()
    
    open var homeUrl: URL?
    
    open func loadUrl(url: URL?) {
        if let u = url {
            self.webView.load(URLRequest(url: u))
        }
    }
    
    open func setupWebView() -> WKWebView {
        let w = WKWebView()
        w.navigationDelegate = self
        self.view.addSubview(w)
        
        w.translatesAutoresizingMaskIntoConstraints = false
        let width = NSLayoutConstraint(item: w,
                                       attribute: NSLayoutAttribute.width,
                                       relatedBy: NSLayoutRelation(rawValue: 0)!,
                                       toItem: self.view,
                                       attribute: NSLayoutAttribute.width,
                                       multiplier: 1.0,
                                       constant: 0)
        let height = NSLayoutConstraint(item: w,
                                        attribute: NSLayoutAttribute.height,
                                        relatedBy: NSLayoutRelation(rawValue: 0)!,
                                        toItem: self.view,
                                        attribute: NSLayoutAttribute.height,
                                        multiplier: 1.0,
                                        constant: 0)
        
        let top = NSLayoutConstraint(item: w,
                                     attribute: NSLayoutAttribute.top,
                                     relatedBy: NSLayoutRelation.equal,
                                     toItem: self.view,
                                     attribute: NSLayoutAttribute.top,
                                     multiplier: 1.0,
                                     constant: 0)
        
        let leading = NSLayoutConstraint(item: w,
                                         attribute: NSLayoutAttribute.leading,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutAttribute.leading,
                                         multiplier: 1.0,
                                         constant: 0)
        
        self.view.addConstraint(width)
        self.view.addConstraint(height)
        self.view.addConstraint(top)
        self.view.addConstraint(leading)
        
        return w
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUrl(url: self.homeUrl)
    }
    
    //MARK: WKNavigationDelegate
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
}
