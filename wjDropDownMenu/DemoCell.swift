//
//  DemoCell.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-22.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

let demoCell = "DemoCell"

class DemoCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
