//
//  UserViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 18.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var userId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserFromServer()
    }
    
    func getUserFromServer() {
        
        ServerManager.manager.getUserWithID(userID: userId,
                                                   success: { (user: User) in
                                                    
                                                    if (user.bigImageURL != nil) {
                                                        self.avatarImageView.af.setImage(withURL: user.bigImageURL!)
                                                    }
                                                    self.fullNameLabel.text = "\(user.firstName) \(user.lastName)"
                                                    
        }) { (error: Error) in
            print("Error = \(error)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination.isKind(of: SubscriptionsTableViewController.self) {
            let userController = segue.destination as! SubscriptionsTableViewController
            userController.userID = selectUserID!
        }
        if segue.destination.isKind(of: FollowersTableViewController.self) {
            let userController = segue.destination as! FollowersTableViewController
            userController.userID = selectUserID!
        }
        if segue.destination.isKind(of: WallTableViewController.self) {
            let userController = segue.destination as! WallTableViewController
            userController.userID = selectUserID!
        }
    }
    
}
