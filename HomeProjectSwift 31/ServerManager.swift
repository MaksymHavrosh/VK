//
//  ServerManager.swift
//  HomeProjectSwift 31
//
//  Created by MG on 18.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import Alamofire

class ServerManager: NSObject {
    
    var accessToken: AccessToken?
    
    
    static let manager: ServerManager = {
        var manager = ServerManager()
        return manager
    }()
    
    class func shareManager() -> ServerManager {
        return manager
    }
    
    func authorizeUzer(completion: @escaping (User) -> Void) {
        
        let vc = LoginViewController.create(with: { (token) in
            
            self.accessToken = token
            
            guard self.accessToken?.userID != nil else { return }
                
                self.getUserWithID(userID: self.accessToken!.userID!,
                              success: { (user) in
                                completion(user)
                }) { (error) in
                    print(error)
                }
            })
        
        let nav = UINavigationController(rootViewController: vc)
        let mainVC = UIApplication.shared.windows.first?.rootViewController
        
        mainVC?.present(nav,
                        animated: true,
                        completion: nil)
    }
    
    func getFriendsWithOffset(offset: Int, count: Int, success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let id = accessToken?.userID else { return }
        
        let params: [String : Any] = ["access_token" : accessToken?.token ?? "72af3c1d72af3c1d72af3c1d9572c05d68772af72af3c1d2c9e03efcc838f15345a65eb",
                                      "v" : "5.103",
                                      "user_id" : id,
                                      "fields" : "photo_100",
                                      "redirect_uri" : "https://oauth.vk.com/blank.html",
                                      "order" : "name",
                                      "count" : count,
                                      "offset" : offset]
        
        AF.request("https://api.vk.com/method/friends.get",
                           method: .get,
                           parameters: params,
                           encoding: URLEncoding.default,
                           headers: nil,
                           interceptor: nil).responseJSON { (response) in
                            
                            switch response.result {
                            case .success(let value):
                                
                                let dictionary = (value as? [String: Any])?["response"] as! [String : Any]
                                let dictsArray = dictionary["items"] as! [[String : Any]]
                                
                                var objectsArray = [User]()
                                
                                for dict in dictsArray {
                                    let user = User(dict: dict)
                                    objectsArray.append(user)
                                }
                                
                                success(objectsArray)
                                
                            case .failure(let error):
                                failure(error)
                            }
                    }
        }
    
    func getUserWithID(userID: Int, success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
        
        let params: [String : Any] = ["access_token" : accessToken?.token ?? "72af3c1d72af3c1d72af3c1d9572c05d68772af72af3c1d2c9e03efcc838f15345a65eb",
                                      "v" : "5.103",
                                      "user_ids" : userID,
                                      "redirect_uri" : "https://oauth.vk.com/blank.html",
                                      "fields" : ["photo_400_orig", "bdate"]]
        
        AF.request("https://api.vk.com/method/users.get",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        
                        let dictObject = (value as! [String : Any])["response"] as? [Any]

                        let user = User(dict: dictObject?.first as! [String : Any])
                        
                        success(user)
                        
                    case .failure(let error):
                        
                        failure(error)
                    }
        }
    }
    
    func getSubscriptionsForUserID(userID: Int, offset: Int, count: Int,
                                   success: @escaping ([Group]) -> Void, failure: @escaping (Error) -> Void) {
        
        let params: [String : Any] = ["access_token" : accessToken?.token ?? "72af3c1d72af3c1d72af3c1d9572c05d68772af72af3c1d2c9e03efcc838f15345a65eb",
                                      "user_id" : userID,
                                      "redirect_uri" : "https://oauth.vk.com/blank.html",
                                      "offset" : offset,
                                      "count" : count,
                                      "fields" : ["name", "photo_100"],
                                      "v" : "5.103",
                                      "extended" : 1]
        
        AF.request("https://api.vk.com/method/users.getSubscriptions",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        
                        let dictionary = (value as? [String: Any])?["response"] as! [String : Any]
                        let dictsArray = dictionary["items"] as! [[String : Any]]
                        
                        var objectsArray = [Group]()
                        
                        for dict in dictsArray {
                            let user = Group(dict: dict)
                            objectsArray.append(user)
                        }
                        
                        success(objectsArray)
                        
                    case .failure(let error):
                        failure(error)
                    }
        }
    }
    
    func getFollowersForUserID(userID: Int, offset: Int, count: Int,
                               success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        
        let params: [String: Any] = ["access_token" : accessToken?.token ?? "72af3c1d72af3c1d72af3c1d9572c05d68772af72af3c1d2c9e03efcc838f15345a65eb",
                                     "user_id" : userID,
                                     "redirect_uri" : "https://oauth.vk.com/blank.html",
                                     "offset" : offset,
                                     "count" : count,
                                     "fields" : ["photo_100"],
                                     "v" : "5.103"]
        
        AF.request("https://api.vk.com/method/users.getFollowers",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        
                        let dictionary = (value as? [String: Any])?["response"] as! [String : Any]
                        let dictsArray = dictionary["items"] as! [[String : Any]]
                        
                        var objectsArray = [User]()
                        
                        for dict in dictsArray {
                            let user = User(dict: dict)
                            objectsArray.append(user)
                        }
                        
                        success(objectsArray)
                        
                    case .failure(let error):
                        failure(error)
                    }
        }
    }
    
    func getWallForUserID(userID: Int, offset: Int, count: Int,
                          success: @escaping ([Post]) -> Void, failure: @escaping (Error) -> Void) {
        
        let params: [String : Any] = ["access_token" : accessToken?.token ?? "72af3c1d72af3c1d72af3c1d9572c05d68772af72af3c1d2c9e03efcc838f15345a65eb",
                                      "owner_id" : userID,
//                                      "extended" : 1,
//                                      "fields" : "all",
                                      "offset" : offset,
                                      "count" : count,
                                      "filter" : "all",
                                      "v" : "5.103"]
        
        AF.request("https://api.vk.com/method/wall.get",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        if let error = (value as? [String: Any])?["error"] {
                            print(error)
                        }
                        
                        guard let dictionary = (value as? [String: Any])?["response"] else { return }
                        
                        let dictsArray = (dictionary as! [String : Any])["items"] as! [[String : Any]]
                        
                        var objectsArray = [Post]()
                        
                        for dict in dictsArray {
                            let post = Post(dict: dict)
                            objectsArray.append(post)
                        }
                        
                        success(objectsArray)
                        
                    case .failure(let error):
                        failure(error)
                    }
        }
    }
    
    func getSubscriptionsForOwner(userID: Int, offset: Int, count: Int,
                                   success: @escaping ([Group]) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let id = accessToken?.userID else { return }
        
        let params: [String : Any] = ["access_token" : accessToken?.token ?? "72af3c1d72af3c1d72af3c1d9572c05d68772af72af3c1d2c9e03efcc838f15345a65eb",
                                      "user_id" : id,
                                      "redirect_uri" : "https://oauth.vk.com/blank.html",
                                      "offset" : offset,
                                      "count" : count,
                                      "fields" : ["name", "photo_100"],
                                      "v" : "5.103",
                                      "extended" : 1]
        
        AF.request("https://api.vk.com/method/users.getSubscriptions",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        
                        let dictionary = (value as? [String: Any])?["response"] as! [String : Any]
                        let dictsArray = dictionary["items"] as! [[String : Any]]
                        
                        var objectsArray = [Group]()
                        
                        for dict in dictsArray {
                            let user = Group(dict: dict)
                            objectsArray.append(user)
                        }
                        
                        success(objectsArray)
                        
                    case .failure(let error):
                        failure(error)
                    }
        }
    }
        
    }


