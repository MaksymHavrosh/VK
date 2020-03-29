
//
//  WallTableViewCell.swift
//  HomeProjectSwift 31
//
//  Created by MG on 23.03.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class WallTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
