//
//  DPMaterialTextField.swift
//  DPMaterial
//
//  Created by Amirhesam Rayatnia on 2018-07-30.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


enum DPMaterialTextFieldType{
    case success
    case normal
    case error
    case disabled
}


@IBDesignable
open class DPMaterialTextField : UIView {
    
    var text_rx: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    @IBInspectable
    public var corner: CGFloat = 2.0 {
        didSet{
            textField.layer.cornerRadius = corner
            update()
            
        }
    }
    var maxLength:Int = 100
    
    var textFieldType: DPMaterialTextFieldType = .normal {
        didSet{
            switch textFieldType {
            case .error:
                borderColors = AppColor.colorFF4070
                borderWidth = 2
            case .success:
                borderWidth = 2
                break
            case .normal:
                borderColors = AppColor.color3D51CC
                borderWidth = 2
            case .disabled:
                borderColors = UIColor(hex: "#808080", alpha: 1.0)
                borderWidth = 1
            }
        }
    }
    

    
    @IBInspectable
    open  var borderColors: UIColor = .black {
        didSet {
            textField.layer.borderColor = borderColors.cgColor
            hintLabel.textColor = borderColors
            placeholderLabel.textColor = borderColors
            update()
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 1.0 {
        didSet {
            textField.layer.borderWidth = borderWidth
            update()
        }
    }
    
    @IBInspectable
    public var placeholderPaddingSize:Float = 16.0 {
        didSet{
            let paddingView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(placeholderPaddingSize), height: self.textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
    }
    
    @IBInspectable
    public var height: CGFloat = 48.0 {
        didSet{
            var frame = textField.frame
            frame.size.height = height
            textField.frame = frame
            update()
        }
    }
    @IBInspectable
    public var hintText: String? = "" {
        didSet {
            hintLabel.text = hintText
        }
    }
    @IBInspectable
    open var placeholder: String? {
        didSet{
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable
    open var title: String? {
        didSet{
            if isFixed{
                placeholderLabel.text = title
                
            }
            
        }
    }
    
    open var text: String {
        set{
            if newValue.count > 0 {
                textField.clearButtonMode = .whileEditing
            }
            textField.text = text
            if textFieldType != .normal {
                textFieldType = .normal
            }
           
//            if isFixed {
//                hintText = ""
//            }
            
            if text.count == 0{
                textFieldType = .disabled
            }
        }
        get {
            return textField.text ?? ""
        }
    }
    
    @IBInspectable
    open var isAccessible: Bool = true
    
    @IBInspectable
    open var isFixed: Bool = true
    
    
    var textField : UITextField = UITextField()
    private var placeholderLabel: UILabel! = UILabel()
    private var hintLabel: UILabel! = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    
    func setup() {
        
        textField.addTarget(self, action: #selector(textChanged(_:)), for: [.editingChanged,.valueChanged])
        placeholderLabel.text = "  test  "
        textField.textAlignment = .right
        textField.font = UIFont(name: "IRANYekan", size: 16)
        placeholderLabel.font = UIFont(name: "IRANYekan", size: 12)
        hintLabel.font = UIFont(name: "IRANYekan-Light", size: 12)
        //hintLabel.font = hintLabel.font.withSize(12)
        placeholderLabel.backgroundColor = .white
        textField.layer.masksToBounds = true
        textField.borderStyle = .line
        addSubview(textField)
        addSubview(placeholderLabel)
        addSubview(hintLabel)
        textField.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.addConstraints(textFieldConst())
        self.addConstraints(hintLabelConstToView())
        self.addConstraints(placeHolderConst())
    }
    
    @objc func textFieldSelected(textField: DPMaterialTextField) {
        //dismissTextFieldKeyboard()
        self.textField.isUserInteractionEnabled = true
        self.textField.becomeFirstResponder()
        textFieldType = .normal
        //borderColors = AppColor.primary
        placeholderLabel.textColor = AppColor.color2C3B94
        // placeholderLabel.fontSize = 12
        if(textField.textField.text == "" && textField.placeholderLabel.isHidden) {
            UIView.animate(withDuration: 0.2) {
                self.placeholderLabel.isHidden = false
                self.textField.placeholder = ""
                self.placeholderLabel.frame.origin.y -= 25.0
                self.placeholderLabel.transform = self.placeholderLabel.transform.scaledBy(x: 4/5, y: 4/5)
            }
        }
        
        
    }
    
    @objc func textChanged(_ textField: UITextField){
        self.text = String((textField.text?.prefix(maxLength))!)
        self.textField.text = String((textField.text?.prefix(maxLength))!)
        text_rx.accept(self.text) 
        // junk it should be fix
        if self.text == "" {
            self.textFieldType = .normal
            self.hintText = ""
        }
    }
    
    
    func update() {
        
        autoresizingMask = [.flexibleWidth,
                            .flexibleHeight]
        self.updateConstraints()
        textField.updateConstraints()
        placeholderLabel.updateConstraints()
        hintLabel.updateConstraints()
        
    }
    
    
    
    private func textFieldConst() -> [NSLayoutConstraint] {
        
        let topConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8)
        let trailingConstraint = NSLayoutConstraint(item: textField, attribute: .trailingMargin , relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: textField, attribute: .leadingMargin , relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        
        return [topConstraint,trailingConstraint,leadingConstraint,heightConstraint]
        
    }
    
    private func hintLabelConstToView() -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: hintLabel as Any, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: 4)
        let trailingConstraint = NSLayoutConstraint(item: hintLabel as Any, attribute: .trailingMargin , relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 4)
        let leadingConstraint = NSLayoutConstraint(item: hintLabel as Any, attribute: .leadingMargin , relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 4)
        return [topConstraint ,trailingConstraint,leadingConstraint]
    }
    
    private func placeHolderConst() -> [NSLayoutConstraint] {
        
        let bottomConstraint = NSLayoutConstraint(item: placeholderLabel as Any, attribute: .bottom, relatedBy: .equal, toItem: textField, attribute: .topMargin, multiplier: 1, constant: 0)
        //placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 100).isActive = true
        
        placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        
        return [bottomConstraint]
    }
}
