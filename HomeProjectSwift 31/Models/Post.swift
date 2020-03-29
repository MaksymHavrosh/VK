//
//  Post.swift
//  HomeProjectSwift 31
//
//  Created by MG on 23.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var text: String
    var imageURL: URL? = nil
    
    init(dict: [String : Any]) {
        
        let text = dict["text"] as! String
        
        if text != "" {
            self.text = dict["text"] as! String
        } else {
            self.text = " "
        }
        
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
