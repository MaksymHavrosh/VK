//
//  User.swift
//  HomeProjectSwift 31
//
//  Created by MG on 18.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let firstName: String
    let lastName: String
    var imageURL: URL? = nil
    var userID: Int? = nil
    let birthDate: Date? = nil
    var bigImageURL: URL? = nil
    
    init(dict: [String : Any]) {
        
        self.firstName = dict["first_name"] as? String ?? "No name"
        self.lastName = dict["last_name"] as? String ?? "No name"
        
        if let url = dict["photo_100"] as? String {
            self.imageURL = URL(string: url)
        }
        
        if let id = dict["id"] as? Int {
            self.userID = id
        }
        
        if let url = dict["photo_400_orig"] as? String {
            self.bigImageURL = URL(string: url)
        }
        
    }

}
