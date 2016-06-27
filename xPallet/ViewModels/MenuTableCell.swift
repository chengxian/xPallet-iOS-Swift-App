//
//  MenuTableCell.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/24/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var titleBack: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleBack.hidden = true
        self.titleBack.layer.cornerRadius = self.titleBack.bounds.height/2
    }
}
