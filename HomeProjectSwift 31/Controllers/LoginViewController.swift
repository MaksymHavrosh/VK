//
//  LoginViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 20.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import WebKit

typealias LoginCompletionBlock = (AccessToken?) -> Void

class LoginViewController: UIViewController, WKNavigationDelegate, UIWebViewDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    var completionBlock: LoginCompletionBlock!
    
    class func initWithCompletionBlock(block: @escaping LoginCompletionBlock) -> LoginViewController {
        
        let vc = LoginViewController()
        
        vc.completionBlock = block
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var r = view.bounds
        r.origin = CGPoint.zero
        
        let webView = WKWebView(frame: r)
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        view.addSubview(webView)
        
        self.webView = webView
        
        navigationItem.title = "Login"
        
        let urlString = "https://oauth.vk.com/authorize?client_id=7299445&scope=139286&redirect_uri=https://oauth.vk.com/blank.html&display=mobile&v=5.103&response_type=token"
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.load(request)
    }
    
    deinit {
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let request = navigationAction.request.url
        let requestString = request!.description
        
        if requestString.contains("#access_token") {
            
            let token = AccessToken()
            
            var query = request!.description
            
            let array = query.components(separatedBy: "#")
            
            if array.count > 1 {
                query = array.last!
            }
            
            let pairs = query.components(separatedBy: "&")
            
            for pair in pairs {
                
                let values = pair.components(separatedBy: "=")
                
                if values.count == 2 {
                    
                    let key = values.first!
                    
                    if key.contains("access_token") {
                        token.token = values.last
                        
                    } else if key.contains("expires_in") {
                        
                        let interval = Double(values.last!)!
                        
                        token.expirationDate = Date(timeIntervalSinceNow: interval)
                        
                    } else if key.contains("user_id") {
                        token.userID = Int(values.last!)
                        
                    } else {
                        print("Error")
                    }
                }
            }
            webView.uiDelegate = nil
            
            if completionBlock != nil {
                completionBlock(token)
            }
            self.dismiss(animated: true, completion: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    //MARK: - Actions
    
    @objc func actionCancel(item: UIBarButtonItem) {
        
        if (completionBlock != nil) {
            completionBlock(nil)
        }
        dismiss(animated: true, completion: nil)
    }

}
