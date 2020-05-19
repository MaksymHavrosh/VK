//
//  LoginViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 20.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class LoginViewController: UIViewController {
    
    typealias LoginCompletion = (AccessToken?) -> Void
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var completionBlock: LoginCompletion?
    private let urlString = "https://oauth.vk.com/authorize?client_id=7299445&scope=204822&redirect_uri=https://oauth.vk.com/blank.html&display=mobile&v=5.103&response_type=token"  // + 2 + 4 + 16 + 131072 + 8192 + 65536 = 204822 (scope)
    
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

        guard let url = URL(string: urlString) else { fatalError("Can't get url from string: \(urlString)") }
        let request = URLRequest(url: url)
        
        webView.navigationDelegate = self
        webView.load(request)
    }
}

// MARK: - Core Data stack

var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "HomeProjectSwift31")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

// MARK: - WKNavigationDelegate

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request.url
        
        if let requestString = request?.description, requestString.contains("#access_token") {
            let accessToken = AccessToken(requestString: requestString)
            
            if let token = accessToken {
                Token.create(from: token)
            }
            
            do {
                try persistentContainer.viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            completionBlock?(accessToken)
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
