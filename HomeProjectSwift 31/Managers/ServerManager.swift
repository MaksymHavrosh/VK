//
//  ServerManager.swift
//  HomeProjectSwift 31
//
//  Created by MG on 18.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import Alamofire

class ServerManager {
    
    static let manager = ServerManager()

    var accessToken: AccessToken?
    
    private var sharedParams: [String: Any] {
        let serviceToken = "72af3c1d72af3c1d72af3c1d9572c05d68772af72af3c1d2c9e03efcc838f15345a65eb"
        return ["access_token": accessToken?.token ?? serviceToken,
                "v": "5.103"]
    }
    
    func getUser(completion: @escaping (User?) -> Void) {
        guard let userId = accessToken?.userID else { return }
        getUserWithID(userID: userId, success: { (user) in
            completion(user)
        }) { (error) in
            print(error)
            completion(nil)
        }
    }
    
    func getFriendsWithOffset(offset: Int, count: Int, success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        guard let id = accessToken?.userID else {
            failure(ServerManagerError.noAccessToken)
            return
        }
        
        let params: [String : Any] = sharedParams + ["user_id" : id,
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
                                
                                guard let dictionary = value as? [String: Any],
                                    let dictObject = dictionary["response"] as? [String: Any],
                                    let dictsArray = dictObject["items"] as? [[String: Any]] else {
                                        failure(VKApiError.noFriendsInRequestForUserID(id: id))
                                        return
                                }
                                
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
        
        let params: [String : Any] = sharedParams + ["user_ids" : userID,
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
                        guard let value = value as? [String: Any],
                            let dictObject = value["response"] as? [Any],
                            let userDict = dictObject.first as? [String: Any]
                            else {
                                failure(VKApiError.noUserWithId(id: userID))
                                return
                            }
                        let user = User(dict: userDict)
                        success(user)
                        
                    case .failure(let error):
                        failure(error)
                    }
        }
    }
    
    func getSubscriptionsForUserID(userID: Int, offset: Int, count: Int,
                                   success: @escaping ([Group]) -> Void, failure: @escaping (Error) -> Void) {
        
        let params: [String : Any] = sharedParams + ["user_id" : userID,
                                                     "redirect_uri" : "https://oauth.vk.com/blank.html",
                                                     "offset" : offset,
                                                     "count" : count,
                                                     "fields" : ["name", "photo_100"],
                                                     "extended" : 1]
        
        AF.request("https://api.vk.com/method/users.getSubscriptions",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        
                        guard let dictionary = value as? [String: Any],
                            let dictObject = dictionary["response"] as? [String: Any],
                            let dictsArray = dictObject["items"] as? [[String: Any]] else {
                                failure(VKApiError.noSubscriptionsForUserID(id: userID))
                                return
                        }
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
        
        let params: [String: Any] = sharedParams + ["user_id" : userID,
                                                    "redirect_uri" : "https://oauth.vk.com/blank.html",
                                                    "offset" : offset,
                                                    "count" : count,
                                                    "fields" : ["photo_100"]]
        
        AF.request("https://api.vk.com/method/users.getFollowers",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        
                        guard let dictionary = value as? [String: Any],
                            let dictsObject = dictionary["response"] as? [String: Any],
                            let dictsArray = dictsObject["items"] as? [[String: Any]] else {
                                failure(VKApiError.noFollowersForUserID(id: userID))
                                return
                        }
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
        
        let params: [String : Any] = sharedParams + ["owner_id" : userID,
                                                     "offset" : offset,
                                                     "count" : count,
                                                     "filter" : "all"]
        
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
                        
                        guard let dictionary = value as? [String: Any],
                            let dictsObject = dictionary["response"] as? [String: Any],
                            let dictsArray = dictsObject["items"] as? [[String: Any]]
                            else {
                                failure(VKApiError.noWallForUserID(id: userID))
                                return
                        }
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
        
        guard let id = accessToken?.userID else {
            failure(ServerManagerError.noAccessToken)
            return
        }
        
        let params: [String : Any] = sharedParams + ["user_id" : id,
                                                     "redirect_uri" : "https://oauth.vk.com/blank.html",
                                                     "offset" : offset,
                                                     "count" : count,
                                                     "fields" : ["name", "photo_100"],
                                                     "extended" : 1]
        
        AF.request("https://api.vk.com/method/users.getSubscriptions",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor: nil).responseJSON { (response) in
                    
                    switch response.result{
                    case .success(let value):
                        
                        guard let dictionary = value as? [String: Any],
                            let dictsObject = dictionary["response"] as? [String : Any],
                            let dictsArray = dictsObject["items"] as? [[String : Any]]
                            else {
                                failure(VKApiError.noSubscriptionsForUserID(id: id))
                                return
                        }
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

// MARK: - Errors

enum ServerManagerError: Error {
    case noAccessToken
}

enum VKApiError: Error {
    case noUserWithId(id: Int)
    case noWallForUserID(id: Int)
    case noSubscriptionsForId(id: Int)
    case noFollowersForUserID(id: Int)
    case noSubscriptionsForUserID(id: Int)
    case noFriendsInRequestForUserID(id: Int)
}
