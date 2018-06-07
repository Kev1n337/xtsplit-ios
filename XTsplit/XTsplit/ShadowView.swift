//
//  ShadowView.swift
//  XTsplit
//
//  Created by Kevin Linne on 13.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
}
