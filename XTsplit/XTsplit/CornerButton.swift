//
//  CornerButton.swift
//  XTsplit
//
//  Created by Kevin Linne on 13.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit

class CornerButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = 2
    }
}
