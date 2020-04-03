//
//  SceneDelegate.swift
//  HomeProjectSwift 31
//
//  Created by MG on 18.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
        var token: String?
        var userId: Int?
        var expirationDate: Date?
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let users = NSFetchRequest<Token>(entityName: "Token")
        users.resultType = .managedObjectResultType
        
        do {
            let user: [Token] = try managedObjectContext.fetch(users)
            
            for data in user {
                token = data.token
                userId = Int(data.userID)
                expirationDate = data.expirationDate
            }
        } catch let error {
            print(error)
        }
        
        if token == nil || userId == nil || expirationDate == nil {
            showLoginViewController()
        } else if let tok = token, let id = userId, let date = expirationDate {
            ServerManager.manager.initAccessToken(token: tok, userId: id, expirationDate: date)
        }
    }
    
}

// MARK: - Private

private extension SceneDelegate {
    
    func showLoginViewController() {
        let loginViewConroler = LoginViewController.create(with: { (token) in
            ServerManager.manager.accessToken = token
        })

        guard let mainVC = window?.rootViewController else { return }
        let nav = UINavigationController(rootViewController: loginViewConroler)
        nav.modalPresentationStyle = .fullScreen
        mainVC.present(nav, animated: false)
    }
    
}
