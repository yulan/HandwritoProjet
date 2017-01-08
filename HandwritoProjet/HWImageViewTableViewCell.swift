//
//  HWImageViewTableViewCell.swift
//  HandwritoProjet
//
//  Created by lan yu on 07/01/2017.
//  Copyright © 2017 lan yu. All rights reserved.
//

import UIKit

class HWImageViewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
