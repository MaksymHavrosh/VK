//
//  Dictionary.swift
//  HomeProjectSwift 31
//
//  Created by Andriy Herasymyuk on 30.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import Foundation

func + <Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    lhs.merging(rhs) { (_, new) in new }
}
