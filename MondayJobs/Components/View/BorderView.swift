//
//  BorderView.swift
//  DigiPay
//
//  Created by Amir Roudsari on 7/23/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import Material
@IBDesignable
class BorderedView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    
    @IBInspectable
    var defaultColor: UIColor = .clear
    @IBInspectable
    var disabledColor: UIColor = .clear
    
    @IBInspectable
    var defaultTextColor: UIColor = .white
    
    @IBInspectable
    var disabledTextColor: UIColor = UIColor.black.withAlphaComponent(0.4)
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var customShadowRadius: CGFloat = 0
    
    @IBInspectable
    var customShadowOpacity: Float  = 0
    
    @IBInspectable
    var customShadowOffset: CGSize = CGSize(width: 0, height: 0)
    
    @IBInspectable
    var customShadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
    
    
    public func shadowEnable(){
        layer.shadowOffset = customShadowOffset
        layer.shadowOpacity = customShadowOpacity
        layer.shadowRadius = customShadowRadius
        self.shadowColor = customShadowColor
        self.depth = Depth(offset: UIOffset(size: customShadowOffset),
                           opacity: customShadowOpacity,
                           radius: customShadowRadius)
        layer.masksToBounds = false
        //        let rect = bounds.insetBy(dx: -4, dy: -4)
        //        layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }
    public func shadowDisable(){
        
        self.depth = Depth(offset: UIOffset(size: .zero),
                           opacity: 0,
                           radius: 0)
        
    }
    
    func innerBorder(){
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.35, height: 0.8)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
    }
    
    @IBInspectable
    override var shadowColor: UIColor? {
        get {
           
            return nil
        }
        set {
           
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
}
