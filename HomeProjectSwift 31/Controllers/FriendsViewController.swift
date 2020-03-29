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

var friendsArray = [User]()
var selectUserID: Int? = nil
var firstTimeAppear: Bool = true

class FriendsViewController: UITableViewController {
    
    let friendsInRequest = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if firstTimeAppear == true {
            
            firstTimeAppear = false
            
            ServerManager.manager.getUser { (user: User) in
                    
                    print("AUTHORIZED!")
                    print("\(user.firstName) \(user.lastName)")
                
                self.getFriendsFromServer()
                }
            }
        }
    
    //MARK: - API

    func getFriendsFromServer() {
        
        ServerManager.manager.getFriendsWithOffset(offset: friendsArray.count,
                                                          count: friendsInRequest,
                                                          success: { (friends: [User]) in
            
                                                            friendsArray.append(contentsOf: friends)
                                                            var newPaths = [IndexPath]()
                                                            
                                                            let i = friendsArray.count - friends.count
                                                            
                                                            for i in i..<friendsArray.count {
                                                                newPaths.append(IndexPath(row: i, section: 0))
                                                            }
                                                            
                                                            self.tableView.beginUpdates()
                                                            self.tableView.insertRows(at: newPaths, with: .top)
                                                            self.tableView.endUpdates()
        }) { (error: Error) in
            print("error = \(error)")
        }
    }
    
    //MARK: - UITableViewDataSourse
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendsArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == friendsArray.count {
            
            let identifier = "LoadMoreCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            }
            
            cell?.textLabel?.text = "Load more"
            cell?.imageView?.image = nil
            
            return cell!
            
        } else {
            
            let identifier = "Cell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            }
            
            let friend = friendsArray[indexPath.row] as User
            
            cell?.textLabel?.text = "\(friend.firstName) \(friend.lastName)"
            cell?.textLabel?.font = .boldSystemFont(ofSize: 16)
            
            guard let imageURL = friend.imageURL else { return cell! }
            
            let imageRequest = URLRequest(url: imageURL)
            cell?.imageView?.af.setImage(withURLRequest: imageRequest)
            
            cell?.accessoryType = .disclosureIndicator
            
            return cell!
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == friendsArray.count {
            getFriendsFromServer()
            
        } else {
            
            selectUserID = friendsArray[indexPath.row].userID
            
            self.performSegue(withIdentifier: "ShowUser", sender: nil)
        }
    }
    
    //MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.destination.isKind(of: UserViewController.self) {
            let userController = segue.destination as! UserViewController
                   userController.userId = selectUserID!
        }

//        if segue.destination.isKind(of: GroupsTableViewController.self) {
//            let userController = segue.destination as! GroupsTableViewController
//            userController.userID = selectUserID!
//        }

    }
    
}

