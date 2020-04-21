//
//  Token+CoreDataClass.swift
//  
//
//  Created by Andriy Herasymyuk on 21.04.2020.
//
//

import Foundation
import CoreData


public class Token: NSManagedObject {
    
    @discardableResult
    class func create(from accessToken: AccessToken) -> Token {
        let token = NSEntityDescription.insertNewObject(forEntityName: String(describing: Token.self), into: persistentContainer.viewContext) as! Token
        token.token = accessToken.token
        token.expirationDate = accessToken.expirationDate
        
        if let userID = accessToken.userID {
            token.userID = NSNumber(value: userID)
        }
        
        return token
    }
    
}
