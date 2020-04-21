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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let users: NSFetchRequest<Token> = Token.fetchRequest()
        users.resultType = .managedObjectResultType
        let user = try? managedObjectContext.fetch(users).first
        
        if let tok = user?.token, let id = user?.userID?.intValue, let date = user?.expirationDate {
            ServerManager.manager.initAccessToken(token: tok, userId: id, expirationDate: date)
        } else {
            showLoginViewController()
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
