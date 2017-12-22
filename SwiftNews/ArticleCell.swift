//
//  ArticleCell.swift
//  SwiftNews
//
//  Created by Sam Catalfo on 8/25/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    
    @IBOutlet var latitude: UILabel!
    @IBOutlet var longitude: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
