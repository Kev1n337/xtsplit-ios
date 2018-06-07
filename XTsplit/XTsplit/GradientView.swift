//
//  GradientView.swift
//  XTsplit
//
//  Created by Kevin Linne on 12.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    // Default Colors
    var colors:[UIColor] = [UIColor(red: 204.0/255.0, green: 219.0/255.0, blue: 39.0/255.0, alpha: 1.0), UIColor(red: 255.0/255.0, green: 8.0/255.0, blue: 0.0/255.0, alpha: 1.0)]
    
    override func draw(_ rect: CGRect) {
        
        // Must be set when the rect is drawn
        setGradient(colors[0], color2: colors[1])
    }
    
    func setGradient(_ color1: UIColor, color2: UIColor) {
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [color1.cgColor, color2.cgColor] as CFArray
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1])!
        
        // Draw Path
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        context?.saveGState()
        path.addClip()
        context?.drawLinearGradient(gradient, start: CGPoint(x: frame.width / 2, y: 0), end: CGPoint(x: frame.width / 2, y: frame.height), options: CGGradientDrawingOptions())
        context?.restoreGState()
    }
    
    override func layoutSubviews() {
        
        // Ensure view has a transparent background color (not required)
        backgroundColor = UIColor.clear
    }
    
}
