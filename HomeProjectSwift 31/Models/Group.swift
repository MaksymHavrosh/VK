//
//  Group.swift
//  HomeProjectSwift 31
//
//  Created by MG on 22.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class Group: NSObject {
    
    var name: String
    var imageURL: URL? = nil
    var groudID: Int? = nil
    
    
    init(dict: [String : Any]) {
        
        if let userFirstName = dict["first_name"] as? String {
            
            let userLastName = dict["last_name"] as? String ?? "No name"

            self.name = "\(userFirstName) \(userLastName)"
        } else {
            self.name = dict["name"] as? String ?? "No name"
        }
        
        self.groudID = dict["id"] as? Int
        
        if self.groudID! > 0 {
            self.groudID = 0 - groudID!
        }
        
        if let url = dict["photo_100"] as? String {
            self.imageURL = URL(string: url)
        }
        
    }

}
