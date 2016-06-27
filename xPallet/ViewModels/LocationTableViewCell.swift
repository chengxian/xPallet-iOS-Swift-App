//
//  LocationTableViewCell.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/9/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationNameSmall: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
