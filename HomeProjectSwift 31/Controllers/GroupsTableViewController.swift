//
//  GroupsTableViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 23.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    var userID: Int = 0
    var groupsArray = [Group]()
    let groupsInRequest = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroupsFromServer(userID: userID)
    }
    
    func getGroupsFromServer(userID: Int) {
        
        ServerManager.shareManager().getSubscriptionsForOwner(userID: userID,
                                                               offset: groupsArray.count,
                                                               count: groupsInRequest,
                                                               success: { (groups) in
                                                                
                                                                self.groupsArray.append(contentsOf: groups)
                                                                
                                                                var newPaths = [IndexPath]()
                                                                
                                                                let i = self.groupsArray.count - groups.count
                                                                
                                                                for i in i..<self.groupsArray.count {
                                                                    newPaths.append(IndexPath(row: i, section: 0))
                                                                }
                                                                
                                                                self.tableView.beginUpdates()
                                                                self.tableView.insertRows(at: newPaths, with: .top)
                                                                self.tableView.endUpdates()
        }) { (error: Error) in
            print(error)
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "GroupCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        if indexPath.row == groupsArray.count {
            cell?.textLabel?.text = "Load more"
            cell?.imageView?.image = nil
        } else {
            
            let group = groupsArray[indexPath.row] as Group
            
            cell?.textLabel?.text = group.name
            cell?.textLabel?.font = .boldSystemFont(ofSize: 16)
            
            guard let imageURL = group.imageURL else { return cell! }
            
            let imageRequest = URLRequest(url: imageURL)
            cell?.imageView?.af.setImage(withURLRequest: imageRequest)
            
            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == groupsArray.count {
            getGroupsFromServer(userID: userID)
        } else {
            
            selectUserID = groupsArray[indexPath.row].groudID

            self.performSegue(withIdentifier: "ShowGroupWall", sender: nil)
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let userController = segue.destination as! WallTableViewController
        userController.userID = selectUserID!

    }

}
