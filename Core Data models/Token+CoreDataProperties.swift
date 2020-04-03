//
//  Token+CoreDataProperties.swift
//  HomeProjectSwift 31
//
//  Created by MG on 02.04.2020.
//  Copyright © 2020 MG. All rights reserved.
//
//

import Foundation
import CoreData


extension Token {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Token> {
        return NSFetchRequest<Token>(entityName: "Token")
    }

    @NSManaged public var token: String?
    @NSManaged public var expirationDate: Date?
    @NSManaged public var userID: Int32

}
