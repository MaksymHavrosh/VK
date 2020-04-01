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
    private var selectedGroupId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroupsFromServer(userID: userID)
    }
    
    func getGroupsFromServer(userID: Int) {
        
        ServerManager.manager.getSubscriptionsForOwner(userID: userID,
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
        if indexPath.row == groupsArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreGroups", for: indexPath)
            cell.textLabel?.text = "Load more"
            cell.imageView?.image = nil
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
            
            let group = groupsArray[indexPath.row] as Group
            
            cell.textLabel?.text = group.name
            cell.textLabel?.font = .boldSystemFont(ofSize: 16)
            
            guard let imageURL = group.imageURL else { return cell }
            
            let imageRequest = URLRequest(url: imageURL)
            cell.imageView?.af.setImage(withURLRequest: imageRequest)
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == groupsArray.count {
            getGroupsFromServer(userID: userID)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            
            selectedGroupId = groupsArray[indexPath.row].groudID

            self.performSegue(withIdentifier: "ShowGroupWall", sender: nil)
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userController = segue.destination as? WallTableViewController, let selectedGroupId = selectedGroupId {
            userController.userID = selectedGroupId
        }
    }

}
