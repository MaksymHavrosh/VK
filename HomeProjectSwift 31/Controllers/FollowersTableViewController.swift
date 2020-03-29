//
//  FollowersTableViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 19.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class FollowersTableViewController: UITableViewController {
    
    var followersArray = [User]()
    let followersInRequest = 20
    var userID: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFollowersForUserID(usetID: userID)
    }
    
    func getFollowersForUserID(usetID: Int) {
        
        ServerManager.shareManager().getFollowersForUserID(userID: usetID,
                                                           offset: followersArray.count,
                                                           count: followersInRequest,
                                                           success: { (followers: [User]) in
                                                            
                                                            self.followersArray.append(contentsOf: followers)
                                                            
                                                            var newPaths = [IndexPath]()
                                                            
                                                            let i = self.followersArray.count - followers.count
                                                            
                                                            for i in i..<self.followersArray.count {
                                                                newPaths.append(IndexPath(row: i, section: 0))
                                                            }
                                                            
                                                            self.tableView.beginUpdates()
                                                            self.tableView.insertRows(at: newPaths, with: .top)
                                                            self.tableView.endUpdates()
        }) { (error: Error) in
            print("Error: \(error)")
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        if indexPath.row == followersArray.count {
            cell?.textLabel?.text = "Load more"
            cell?.imageView?.image = nil
            
        } else {
            
            let follower = followersArray[indexPath.row]
            
            cell?.textLabel?.text = "\(follower.firstName) \(follower.lastName)"
            cell?.textLabel?.font = .boldSystemFont(ofSize: 16)
            
            guard let imageURL = follower.imageURL else { return cell! }
            
            let imageRequest = URLRequest(url: imageURL)
            
            cell?.imageView?.af.setImage(withURLRequest: imageRequest)
        }
        return cell!
    }
    
    //MARK: -UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == followersArray.count {
            getFollowersForUserID(usetID: userID)
            
        }
//        else {
//
//            selectUserID = friendsArray[indexPath.row].userID
//
//            self.performSegue(withIdentifier: "ShowFollower", sender: nil)
//
//        }
        
//        //MARK: - Segue
//
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//            let userController = segue.destination as! UserViewController
//            userController.userId = selectUserID!
//
//        }
    }
}
