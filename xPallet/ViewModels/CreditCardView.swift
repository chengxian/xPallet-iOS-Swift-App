//
//  CreditCardView.swift
//  xPallet
//
//  Created by ChengXian Lim on 11/25/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

class CreditCardView: UIView {

    @IBOutlet weak var imgVisaLogo: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardExpireEndDate: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        let layer = self.layer as CALayer
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        layer.shadowPath = UIBezierPath(rect: CGRectMake(0, 2, self.frame.size.width + 8, self.frame.size.height + 8)).CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 50.0
        layer.shadowOffset = CGSizeMake(0, 0)
        self.clipsToBounds = false
    }
}
