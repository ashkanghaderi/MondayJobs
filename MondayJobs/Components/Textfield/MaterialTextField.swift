//
//  MaterialTextField.swift
//  DigiPay
//
//  Created by Farshad Mousalou on 12/15/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit
import MaterialComponents

@IBDesignable
class MaterialTextField: MDCTextField {
    
    /// <#Description#>
    ///
    /// - legacy: <#legacy description#>
    /// - legacyFullWidth: <#legacyFullWidth description#>
    /// - filled: <#filled description#>
    /// - fullWidth: <#fullWidth description#>
    /// - outlined: <#outlined description#>
    /// - underline: <#underline description#>
    @objc
    enum MaterialTextFieldStyle : Int {
        case legacy
        case legacyFullWidth
        case filled
        case fullWidth
        case outlined
        case underline
    }
    
    override var font: UIFont?{
        get{
            return super.font
        }
        set(newValue) {
            guard super.font != newValue else { return }
            super.font = newValue
        }
    }
    
    
    @IBInspectable
    var style : MaterialTextFieldStyle = .outlined {
        didSet{
            self.update(style: style)
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var normalColor : UIColor? = AppColor.color4D4D4D {
        didSet{
            controller.normalColor = normalColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var activeColor : UIColor? = AppColor.color3D51CC {
        didSet{
            controller.activeColor = activeColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var disabledColor : UIColor? = UIColor.black.withAlphaComponent(0.2) {
        didSet{
            controller.disabledColor = disabledColor
            setNeedsLayout()
        }
    }
    
    
    @IBInspectable
    var errorColor : UIColor? = AppColor.colorFF4070 {
        didSet{
            controller.errorColor = errorColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var clearButtonTintColor : UIColor? = nil {
        didSet{
            controller.textInputClearButtonTintColor = clearButtonTintColor ?? AppColor.colorF2F2F2
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var underlineColor : UIColor? = nil {
        didSet{
            self.underline?.color = underlineColor
            
        }
    }
    
    var inlinePlaceHolderFont : UIFont? = .font(with: .regular(size:14)) {
        didSet{
            controller.inlinePlaceholderFont = inlinePlaceHolderFont ?? self.font
            setNeedsLayout()
        }
    }
    
    var helperFont : UIFont? = .font(with: .light(size:12.0)) {
        didSet{
            controller.leadingUnderlineLabelFont = helperFont ?? self.font
            controller.trailingUnderlineLabelFont = helperFont ?? self.font
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var hintPlaceHolderText : String? {
        didSet{
            controller.placeholderText = hintPlaceHolderText
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var hintPlaceholderTextColor : UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var helperText : String? = nil {
        didSet{
            controller.setHelperText(helperText, helperAccessibilityLabel: helperText)
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var errorText : String? = nil {
        didSet{
            guard let errorText = errorText else {
                controller.setErrorText(nil, errorAccessibilityValue: nil)
                return
            }
            
            controller.setErrorText(errorText, errorAccessibilityValue: errorText)
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var isFloatingEnabled : Bool = true {
        didSet{
            (controller as? MDCTextInputControllerFloatingPlaceholder)?.isFloatingEnabled = isFloatingEnabled
             setNeedsLayout()
        }
    }
    
    @IBInspectable
    var underlineViewMode: UITextField.ViewMode = .whileEditing {
        didSet{
            controller.underlineViewMode = underlineViewMode
            setNeedsLayout()
        }
    }
    
    // textField Controller
    private(set) var controller : MDCTextInputController!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        self.commonInit()
        super.prepareForInterfaceBuilder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isFloatingEnabled, self.textAlignment == .center {
            self.placeholderLabel.textAlignment = self.textAlignment
            self.placeholderLabel.frame = self.textRect(forBounds: self.bounds)
        }
    }
    
//    override var intrinsicContentSize: CGSize {
//        var contentSize = super.intrinsicContentSize
//        contentSize.height = self.helperText.isEmptyOrBlank ? 60 : 80
//        return contentSize
//    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

// MARK: - Private UI methods
fileprivate extension MaterialTextField {
    
    
    func commonInit() {
        
        self.mdc_adjustsFontForContentSizeCategory = false
        self.controller = self.controller(withStyle: self.style)
        self.controller.mdc_adjustsFontForContentSizeCategory = false
        self.controller.textInput = self
        self.controller.textInputFont = UIFont.font(with: .regular(size:16.0))
        self.controller.activeColor = activeColor
        self.controller.normalColor = normalColor
        self.controller.disabledColor = disabledColor
        self.controller.errorColor = errorColor
        self.controller.inlinePlaceholderFont = self.inlinePlaceHolderFont
        self.controller.trailingUnderlineLabelFont = self.helperFont
        self.controller.leadingUnderlineLabelFont = self.helperFont
//        self.controller.placeholderText = self.placeholder
        self.controller.underlineViewMode = self.underlineViewMode
        (self.controller as? MDCTextInputControllerFloatingPlaceholder)?.isFloatingEnabled = isFloatingEnabled
        
        
//        self.hidesPlaceholderOnInput = false
        
        self.font = UIFont.font(with: .regular(size: 16.0))
        
    }
    
    func update(style newStyle : MaterialTextFieldStyle) {
        self.updateController(from: controller, to: self.controller(withStyle: newStyle))
        self.controller.textInput = self
        
        setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func controller(withStyle style: MaterialTextFieldStyle) -> MDCTextInputController{
        
        let newController : MDCTextInputController
        switch (style) {
        case .legacy:
            newController = MDCTextInputControllerLegacyDefault()
        case .legacyFullWidth:
            newController = MDCTextInputControllerLegacyFullWidth()
        case .outlined:
            newController = MaterialTextInputControllerOutlined()
        case .underline:
            newController = MDCTextInputControllerUnderline()
        case .filled:
            newController = MDCTextInputControllerFilled()
        case .fullWidth:
            newController = MDCTextInputControllerFullWidth()
        }
        
        return newController
    }
    
    func updateController(from oldController : MDCTextInputController, to newController : MDCTextInputController) {
        
        //TODO update controller
        
        // assigning old properties values to new one
        
        // Color
        newController.activeColor = oldController.activeColor
        newController.disabledColor = oldController.disabledColor
        newController.errorColor = oldController.errorColor
        newController.normalColor = oldController.normalColor
        newController.inlinePlaceholderColor = oldController.inlinePlaceholderColor
        newController.leadingUnderlineLabelTextColor = oldController.leadingUnderlineLabelTextColor
        newController.trailingUnderlineLabelTextColor = oldController.trailingUnderlineLabelTextColor
        newController.textInputClearButtonTintColor = oldController.textInputClearButtonTintColor
        
        // Font
        newController.inlinePlaceholderFont = oldController.inlinePlaceholderFont
        newController.textInputFont = oldController.textInputFont
        newController.trailingUnderlineLabelFont = oldController.trailingUnderlineLabelFont
        newController.leadingUnderlineLabelFont = oldController.leadingUnderlineLabelFont
        
        // text
        newController.placeholderText = oldController.placeholderText
        newController.setErrorText(oldController.errorText, errorAccessibilityValue: nil)
        newController.helperText = oldController.helperText
        
        newController.underlineViewMode = self.underlineViewMode
        newController.characterCountViewMode = oldController.characterCountViewMode
        
        (newController as? MDCTextInputControllerFloatingPlaceholder)?.isFloatingEnabled = isFloatingEnabled
        
        self.controller = newController
        
        
    }
    
}
