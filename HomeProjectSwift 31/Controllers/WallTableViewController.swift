//
//  WallTableViewController.swift
//  HomeProjectSwift 31
//
//  Created by MG on 19.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class WallTableViewController: UITableViewController {
    
    var userID: Int = 0
    var postsArray = [Post]()
    let postsInRequest = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWallFromServerForUserID(userID: userID)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func getWallFromServerForUserID(userID: Int) {
            
        ServerManager.manager.getWallForUserID(userID: userID,
                                                      offset: postsArray.count,
                                                      count: postsInRequest,
                                                      success: { [weak self] (posts) in // TODO: Розібратися коли `[weak self]` потрібно і коли ні
                                                        guard let self = self else { return }
                                                        
                                                        self.postsArray.append(contentsOf: posts)
                                                        
                                                        var newPaths = [IndexPath]()
                                                        
                                                        let i = self.postsArray.count - posts.count
                                                        
                                                        for i in i..<self.postsArray.count {
                                                            newPaths.append(IndexPath(row: i, section: 0))
                                                        }
                                                        
                                                        self.tableView.beginUpdates()
                                                        self.tableView.insertRows(at: newPaths, with: .top)
                                                        self.tableView.endUpdates()
        },
          failure: { (error: Error) in
            print(error)
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == postsArray.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMorePosts", for: indexPath)
            
            cell.textLabel?.text = NSLocalizedString("Load more", comment: "")
            cell.imageView?.image = nil
            
            return cell
            
        } else {
            
            let post = postsArray[indexPath.row]
            
            if let imageURL = post.imageURL {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WallTableViewCell.self), for: indexPath) as! WallTableViewCell
                
                cell.postImage.image = #imageLiteral(resourceName: "Question")
                cell.postTextLabel.text = post.text
                
                let imageRequest = URLRequest(url: imageURL)
                cell.postImage.af.setImage(withURLRequest: imageRequest)
                
                return cell
            } else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextPost", for: indexPath) as? TextPostTableViewCell else {
                    return UITableViewCell()
                }
                
                tableView.rowHeight = UITableView.automaticDimension
                cell.textPostLabel?.text = post.text
                cell.imageView?.image = nil
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == postsArray.count {
            getWallFromServerForUserID(userID: userID)
        }
    }

}
