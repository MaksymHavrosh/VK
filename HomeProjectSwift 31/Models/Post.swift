//
//  Post.swift
//  HomeProjectSwift 31
//
//  Created by MG on 23.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class Post {
    
    var text: String
    var imageURL: URL?
    
    init?(dict: [String : Any]) {
        
        guard let text = dict["text"] as? String, !text.isEmpty else { return nil }
        
        self.text = text
        
        guard let attach = (dict)["attachments"] as? [[String: Any]] else { return }
            
        for object in attach {
            
            if let photo = object["photo"] as? [String : Any] {
                
                if let size = photo["sizes"] as? [[String : Any]] {
                    
                    if let url = size.last!["url"] as? String {
                        imageURL = URL(string: url)
                    }
                }
            }
        }
    }

}
