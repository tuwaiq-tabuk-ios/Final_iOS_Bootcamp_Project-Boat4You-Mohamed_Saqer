//
//  UIView+Ext.swift
//  Boat4You
//
//  Created by Mohammed on 17/06/1443 AH.
//

import UIKit

extension UIView {
    
  
  
    func dropShadow(scale: Bool = true, radius: CGFloat, opacity: Float, color: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = radius

        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

