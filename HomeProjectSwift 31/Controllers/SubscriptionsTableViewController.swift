//
//  SubscriptionsTableViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 19.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class SubscriptionsTableViewController: UITableViewController {
    
    var groupsArray = [Group]()
    var userID: Int = 0
    let groupInRequest = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSubscriptionsForUserID(userID: userID)
    }
    
    func getSubscriptionsForUserID(userID: Int) {
        
        ServerManager.manager.getSubscriptionsForUserID(userID: userID,
                                                               offset: groupsArray.count,
                                                               count: groupInRequest,
                                                               success: { (pagesArray: [Group]) in
                                                                
                                                                self.groupsArray.append(contentsOf: pagesArray)
                                                                
                                                                var newPaths = [IndexPath]()
                                                                
                                                                let i = self.groupsArray.count - pagesArray.count
                                                                
                                                                for i in i..<self.groupsArray.count {
                                                                    newPaths.append(IndexPath(row: i, section: 0))
                                                                }
                                                                
                                                                self.tableView.beginUpdates()
                                                                self.tableView.insertRows(at: newPaths, with: .top)
                                                                self.tableView.endUpdates()
        }) { (error: Error) in
            print("Error = \(error)")
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionsCell", for: indexPath)
        
        if indexPath.row == groupsArray.count {
            cell.textLabel?.text = "Load more"
            cell.imageView?.image = nil
        } else {
            
            let group = groupsArray[indexPath.row] as Group
            
            cell.textLabel?.text = group.name
            cell.textLabel?.font = .boldSystemFont(ofSize: 16)
            
            guard let imageURL = group.imageURL else { return cell }
            
            let imageRequest = URLRequest(url: imageURL)
            cell.imageView?.af.setImage(withURLRequest: imageRequest)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == groupsArray.count {
            getSubscriptionsForUserID(userID: userID)
        }
    }

}
