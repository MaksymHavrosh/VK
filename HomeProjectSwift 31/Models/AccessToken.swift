//
//  AccessToken.swift
//  HomeProjectSwift 31
//
//  Created by MG on 20.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

struct AccessToken {
    
    var token: String?
    var expirationDate: Date?
    var userID: Int?
    
    init(token: String?, expirationDate: Date?, userID: Int?) {
        self.token = token
        self.expirationDate = expirationDate
        self.userID = userID
    }
        
    init?(requestString: String) {
        guard requestString.contains("#access_token") else { return nil }
        
        var query = requestString
        let array = query.components(separatedBy: "#")
        
        if array.count > 1, let last = array.last {
            query = last
        }
        
        let pairs = query.components(separatedBy: "&")
        
        for pair in pairs {
            let values = pair.components(separatedBy: "=")
            
            if values.count == 2, let firstValue = values.first, let lastValue = values.last {
                let key = firstValue
                
                if key.contains("access_token") {
                    token = values.last
                    
                } else if key.contains("expires_in"), let interval = Double(lastValue) {
                    expirationDate = Date(timeIntervalSinceNow: interval)
                    
                } else if key.contains("user_id") {
                    userID = Int(lastValue)
                    
                } else {
                    print("Not valid key: \(key)")
                }
            }
        }
    }

}
