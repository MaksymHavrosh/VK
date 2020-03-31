//
//  FriendsViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 18.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FriendsViewController: UITableViewController {
    
    private let friendsInRequest = 20
    private var friendsArray: [User] = []
    private var firstTimeAppear = true
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if friendsArray.isEmpty {
            getFriendsFromServer()
        }
        
        if firstTimeAppear {
            // just for test
            firstTimeAppear = false
            ServerManager.manager.getUser { (user: User?) in
                if let user = user {
                    print("AUTHORIZED!")
                    print("\(user.firstName) \(user.lastName)")
                }
            }
        }
    }
    
    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userController = segue.destination as? UserViewController,
            let selectedRow = tableView.indexPathForSelectedRow?.row,
            let selectUserID = friendsArray[selectedRow].userID {
            
            userController.userId = selectUserID
        }
    }
    
}

// MARK: - Private

private extension FriendsViewController {
    
    func getFriendsFromServer() {
        ServerManager.manager.getFriendsWithOffset(offset: friendsArray.count,
                                                   count: friendsInRequest,
                                                   success: { [weak self] (friends: [User]) in
                                                    guard let self = self else { return }
                                                    
                                                    self.friendsArray.append(contentsOf: friends)
                                                    var newPaths: [IndexPath] = []
                                                    
                                                    let i = self.friendsArray.count - friends.count
                                                    
                                                    for i in i..<self.friendsArray.count {
                                                        newPaths.append(IndexPath(row: i, section: 0))
                                                    }
                                                    
                                                    self.tableView.beginUpdates()
                                                    self.tableView.insertRows(at: newPaths, with: .top)
                                                    self.tableView.endUpdates()
        }) { (error: Error) in
            print("error = \(error)")
        }
    }
    
}

// MARK: - UITableViewDataSourse

extension FriendsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendsArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == friendsArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell", for: indexPath)
            cell.textLabel?.text = "Load more"
            cell.imageView?.image = nil
            return cell
            
        } else {
            let friend = friendsArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "\(friend.firstName) \(friend.lastName)"
            cell.textLabel?.font = .boldSystemFont(ofSize: 16)
            cell.accessoryType = .disclosureIndicator
            
            if let imageURL = friend.imageURL {
                let imageRequest = URLRequest(url: imageURL)
                cell.imageView?.af.setImage(withURLRequest: imageRequest)
            }
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension FriendsViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == friendsArray.count {
            getFriendsFromServer()
        }
    }
    
}
