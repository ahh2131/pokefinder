//
//  MonsterTableViewCell.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/16/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit

class MonsterTableViewCell: UITableViewCell {

    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var monsterImage: UIImageView!
    @IBOutlet weak var monsterScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
