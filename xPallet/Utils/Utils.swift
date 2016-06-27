//
//  Utils.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/7/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit

extension String {
   
    func insertString (str: String, index: Int) -> String{
        let prefixString = String(self.characters.prefix(index))
        let suffixString = String(self.characters.suffix(self.characters.count - index))
        
        return prefixString + str + suffixString
    }
}
