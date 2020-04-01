//
//  LoginViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 20.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    typealias LoginCompletion = (AccessToken?) -> Void
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var completionBlock: LoginCompletion?
    
    class func create(with completion: @escaping LoginCompletion) -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as LoginViewController
        vc.completionBlock = completion
        return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
                
        navigationItem.title = "Login"
        
        let urlString = "https://oauth.vk.com/authorize?client_id=7299445&scope=139286&redirect_uri=https://oauth.vk.com/blank.html&display=mobile&v=5.103&response_type=token"

        guard let url = URL(string: urlString) else {
            fatalError("Can't get url from string: \(urlString)")
        }
        let request = URLRequest(url: url)
        
        webView.navigationDelegate = self
        
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request.url
        
        if let requestString = request?.description, requestString.contains("#access_token") {
            var token = AccessToken()
            var query = requestString
            let array = query.components(separatedBy: "#")
            
            if array.count > 1, let last = array.last {
                query = last
            }
            
            let pairs = query.components(separatedBy: "&")
            
            for pair in pairs {
                let values = pair.components(separatedBy: "=")
                
                if values.count == 2, let firstValue = values.first, let lastValue = values.last {
                    let key = firstValue
                    
                    if key.contains("access_token") {
                        token.token = values.last
                        
                    } else if key.contains("expires_in"), let interval = Double(lastValue) {
                        token.expirationDate = Date(timeIntervalSinceNow: interval)
                        
                    } else if key.contains("user_id") {
                        token.userID = Int(lastValue)
                        
                    } else {
                        print("Not validate key: \(key)")
                    }
                }
            }
            
            completionBlock?(token)
            dismiss(animated: true, completion: nil)
            decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
}
