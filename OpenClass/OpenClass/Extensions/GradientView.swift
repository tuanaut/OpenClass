//
//  GradientViewTheme.swift
//  OpenClass
//
//  Created by Jerry Chiu on 11/9/17.
//  Copyright © 2017 CS472. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var FirstColor: UIColor = UIColor(r: 205, g: 35, b: 35) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var SecondColor: UIColor = UIColor(r: 0, g: 0, b: 0) {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
    }
    
}

// Convienience; instead of doing UIColor(red: CGFloat, green: CGFloat, blue: CGFloat) every time
extension UIColor
{
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
