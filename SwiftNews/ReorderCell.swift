//
//  ReorderCell.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 11/3/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit

class ReorderCell: UITableViewCell {

    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var thumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
