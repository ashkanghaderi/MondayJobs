//
//  TKFormTextField.swift
//  TKFormTextField
//
//  A UITextField whose placeholder text moves up when text is entered.
//  There's also an underline, and a multi-line error text can be displayed below.
//  Set error to show/hide error and trigger error coloring.
//
//  Created by Thongchai Kolyutsakul on 30/11/16.
//  Copyright © 2016 Thongchai Kolyutsakul. All rights reserved.
//

import UIKit

open class TKFormTextField: UITextField {
    
    
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    fileprivate final func setup() {
        self.borderStyle = .none
        self.createTitleLabel()
        self.createErrorLabel()
        self.createLineView()
        self.updateColors()
        self.updateTextAligment()
        self.addTarget(self, action: #selector(tk_editingChanged), for: .editingChanged)
    }
    
    @objc open func tk_editingChanged() {
        updateControl(true)
        updateTitleLabel(true)
    }
    
    // MARK: Views
    open var titleLabel: UILabel! // the label above input text
    open var lineView: UIView! // the line below input text
    open var errorLabel: UILabel! // the error label below input text
    
    // MARK: Animation
    open var titleFadeInDuration: TimeInterval = 0.2
    open var titleFadeOutDuration: TimeInterval = 0.3
    
    // MARK: Colors
    override open var textColor: UIColor? {
        didSet {
            self.updateControl(false)
        }
    }
    
    open var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    open var placeholderFont: UIFont? {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    open var titleColor: UIColor = UIColor.lightGray {
        didSet {
            self.updateTitleColor()
        }
    }
    
    open var selectedTitleColor: UIColor = UIColor.gray {
        didSet {
            self.updateTitleColor()
        }
    }
    
    open var lineColor: UIColor = UIColor.lightGray {
        didSet {
            self.updateLineView()
        }
    }
    
    open var selectedLineColor: UIColor = UIColor.black {
        didSet {
            self.updateLineView()
        }
    }
    
    open var errorColor: UIColor = AppColor.colorFF4070 {
        didSet {
            self.updateColors()
        }
    }
    
    open var lineHeight: CGFloat = 0.5 {
        didSet {
            self.updateLineView()
            self.setNeedsDisplay()
        }
    }
    
    open var selectedLineHeight: CGFloat = 1.0 {
        didSet {
            self.updateLineView()
            self.setNeedsDisplay()
        }
    }
    
    open var lastErrorHeight: CGFloat = 0
    
    
    
    // MARK: Properties
    
    // Identifies whether the text object should hide the text being entered.
    override open var isSecureTextEntry: Bool {
        set {
            super.isSecureTextEntry = newValue
            self.fixCaretPosition()
        }
        get {
            return super.isSecureTextEntry
        }
    }
    
    // A string for errorLabel
    open var error: String? {
        didSet {
            self.updateControl(true)
            setNeedsLayout()
        }
    }
    
    // A string for errorLabel
    open var textDescription: String? {
        didSet {
            self.updateControl(true)
        }
    }
    
    open var secondHint: String? {
        didSet {
            self.updateControl(true)
        }
    }
    
    
    
    // A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        get {
            return super.isEditing || self.isSelected
        }
    }
    
    // A Boolean value that determines whether the receiver has an error message.
    open var hasError: Bool {
        get {
            return self.error != nil && self.error != ""
        }
    }
    
    open var hasDescription: Bool {
        get {
            return self.textDescription != nil && self.textDescription != ""
        }
    }
    
    open var hasSecondHint: Bool {
        get {
            return self.secondHint != nil && self.secondHint != ""
        }
    }
    
    fileprivate var _renderingInInterfaceBuilder: Bool = false
    
    // The text content of the textfield
    override open var text: String? {
        didSet {
            self.updateControl(false)
        }
    }
    
    // The String to display when the input field is empty.
    // The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
    override open var placeholder: String? {
        didSet {
            self.setNeedsDisplay()
            self.updatePlaceholder()
            // self.updateTitleLabel()
        }
    }
    
    // The String to display when the textfield is editing and the input is not empty.
    open var selectedTitle: String? {
        didSet {
            self.updateControl()
        }
    }
    
    // The String to display when the textfield is not editing and the input is not empty.
    open var title: String? {
        didSet {
            self.updateControl()
        }
    }
    
    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected: Bool {
        didSet {
            self.updateControl(true)
        }
    }
    
    // MARK: create components
    
    fileprivate func createTitleLabel() {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont(name: "IRANYekan(FaNum)", size: 14)
//        label.font = self.font?.withSize(14.0)
        label.alpha = 0.8
        //label.text = self.title
        label.textColor = UIColor.black
        label.accessibilityIdentifier = "title-label"
        self.addSubview(label)
        self.titleLabel = label
    }
    
    fileprivate func createLineView() {
        let view = UIView()
        self.lineView = view
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        self.lineHeight = 2.0 * onePixel // self.lineHeight uses self.lineView so have to set it first
        self.selectedLineHeight = 2.0 * self.lineHeight
        view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.isUserInteractionEnabled = false
        view.accessibilityIdentifier = "line-view"
        self.addSubview(view)
    }
    
    fileprivate func createErrorLabel() {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont(name: "IRANYekan(FaNum)", size: 12)
        label.alpha = 1.0
        label.numberOfLines = 0
      //  label.textColor = self.errorColor
        label.accessibilityIdentifier = "error-label"
        self.addSubview(label)
        self.errorLabel = label
    }
    
    // MARK: Responder handling
    
    // Attempt the control to become the first responder
    // - returns: True when successfully becoming the first responder
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateControl(true)
        return result
    }
    
    // Attempt the control to resign being the first responder
    // - returns: True when successfully resigning being the first responder
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.updateControl(true)
        return result
    }
    
    // MARK: - View updates
    
    fileprivate func updateControl(_ animated:Bool = false) {
        self.invalidateIntrinsicContentSize()
        self.updateColors()
        self.updateLineView()
        //self.updateTitleLabel(animated)
        self.updateErrorLabel(animated)
        self.updateDescriptionLabel(animated)
    }
    
    fileprivate func updateLineView() {
        if let lineView = self.lineView {
            lineView.frame = self.lineViewRectForBounds(CGRect(origin: CGPoint(x: 0, y: 0), size: self.bounds.size), editing: self.editingOrSelected)
        }
        self.updateLineColor()
    }
    
    fileprivate func updatePlaceholder() {
        if let placeholder = self.titleOrPlaceholder(), let font = self.placeholderFont ?? self.font {
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: placeholderColor, .font: font]
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
    }
    
    // MARK: - Color updates
    
    // Update the colors for the control. Override to customize colors.
    open func updateColors() {
        self.updateLineColor()
        self.updateTitleColor()
    }
    
    fileprivate func updateLineColor() {
        UIView.animate(withDuration: 0.4) {
            if self.hasError {
                self.lineView.backgroundColor = self.errorColor
                self.titleLabel.textColor = self.errorColor
                self.errorLabel.textColor = self.errorColor
            } else if self.isEditing {
                self.lineView.backgroundColor = AppColor.color3D51CC
                self.titleLabel.textColor = AppColor.color3D51CC
                self.errorLabel.textColor = AppColor.color3D51CC
               
            } else{
                self.lineView.backgroundColor = UIColor.clear
                
            }
        }
    }
    
    fileprivate func updateTitleColor() {
        if self.editingOrSelected {
            self.titleLabel.textColor = AppColor.color3D51CC
        } else {
            self.titleLabel.textColor = self.titleColor
        }
    }
    
    // MARK: - Title handling
    
    fileprivate func updateTitleLabel(_ animated:Bool = false) {
        self.titleLabel.text = self.title
        
       
        //  self.updateTitleVisibility(animated)
    }
    
    fileprivate func updateErrorLabel(_ animated:Bool = false) {
        self.errorLabel.text = error
        updatePlaceholder()
        
    }
    
    fileprivate func updateDescriptionLabel(_ animated:Bool = false) {
        if !hasError{
            self.errorLabel.text = textDescription
        }        
    }
    
    fileprivate var _titleVisible = false
    
    // Set this value to make the title visible
    open func setTitleVisible(_ titleVisible:Bool, animated:Bool = false, animationCompletion: (()->())? = nil) {
        if(_titleVisible == titleVisible) {
            return
        }
        _titleVisible = titleVisible
        self.updateTitleColor()
    }
    
    // Returns whether the title is being displayed on the control.
    open func isTitleVisible() -> Bool {
        return self.hasText || _titleVisible
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let titleHeight = self.titleHeight()
        let lineHeight = self.selectedLineHeight
        let errorHeight = self.errorHeight()
        var rect: CGRect!

        
        if hasError {
            if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
                clearButton.setImage(UIImage(named:"error"), for: .normal)
                clearButton.setImage(UIImage(named:"error"), for: .highlighted)
                clearButton.alpha = 1.0
            }
            rect = CGRect(x: 44, y: 15, width: bounds.size.width - 150, height: bounds.size.height - titleHeight - lineHeight - errorHeight)
        } else if isEditing {
            if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
                clearButton.setImage(UIImage(named:"remove"), for: .normal)
                clearButton.setImage(UIImage(named:"remove"), for: .highlighted)
                clearButton.alpha = 1.0
            }
            if(self.text != ""){
                rect = CGRect(x: 44, y: 15, width: bounds.size.width - 150, height: bounds.size.height - titleHeight - lineHeight - errorHeight)
            } else {
                rect =  CGRect(x: 16, y: 15, width: bounds.size.width - 150, height: bounds.size.height - titleHeight - lineHeight - errorHeight)
            }
            
        } else {
            if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
                clearButton.setImage(UIImage(named:"remove"), for: .normal)
                clearButton.setImage(UIImage(named:"remove"), for: .highlighted)
                clearButton.alpha = 0.0
            }
            rect =  CGRect(x: 16, y: 15, width: bounds.size.width - 150, height: bounds.size.height - titleHeight - lineHeight - errorHeight)
        }
        
        return rect
        
    }
    
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: 16, y: 18) , size:CGSize(width: 20, height: 20))
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = textRect(forBounds: bounds)
        rect.size.width = 34
        rect.origin.x = bounds.size.width - rect.size.width
        return rect
    }
    
    
    
    // MARK: - Custom view positioning overrides
    
    open func titleLabelRectForBounds(_ bounds: CGRect, editing:Bool) -> CGRect {
        let titleHeight = self.titleHeight()

        return CGRect(x: 0, y: 17, width: bounds.size.width - 16, height: titleHeight)
    }
    
    open func lineViewRectForBounds(_ bounds: CGRect, editing:Bool) -> CGRect {
        let lineHeight: CGFloat = editing ? CGFloat(self.selectedLineHeight) : CGFloat(self.lineHeight)
        return CGRect(x: 0, y: bounds.size.height - lineHeight - errorHeight() - 5, width: bounds.size.width - 16, height: lineHeight)
    }
    
    open func errorLabelRectForBounds(_ bounds: CGRect) -> CGRect {
//        guard let description = textDescription, !description.isEmpty else { return CGRect.zero }
        var error: String
        if(self.error != nil){
            error = self.error!
        } else if(self.textDescription != nil && self.isEditing){
            error = textDescription!
        } else{
            return CGRect.zero
        }
        
        let font: UIFont = errorLabel.font ?? UIFont(name: "IRANYekan(FaNum)", size: 12)!
        
        let textAttributes = [.font: font] as [NSAttributedString.Key:Any]
        let s = CGSize(width: bounds.size.width, height: 2000)
        let boundingRect = error.boundingRect(with: s, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return CGRect(x: self.bounds.size.width - boundingRect.size.width - 16, y: bounds.size.height - boundingRect.size.height - 3, width: boundingRect.size.width, height: boundingRect.size.height)
    }
    
    // Calculate the height of the top title label.
    open func titleHeight() -> CGFloat {
        if let titleLabel = self.titleLabel,
            let font = titleLabel.font {
                return font.lineHeight
        }
        return 20.0
        
    }
    
    // Calcualte the height of the textfield.
    open func textHeight() -> CGFloat {
        return (self.font?.lineHeight ?? 20.0) + 7.0
    }
    
    open func errorHeight() -> CGFloat {
        return self.errorLabelRectForBounds(self.bounds).size.height
    }
    
    // MARK: - Layout
    
    // Invoked when the interface builder renders the control
    override open func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }
        self.isSelected = true
        _renderingInInterfaceBuilder = true
        self.updateControl(false)
        self.invalidateIntrinsicContentSize()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
        self.errorLabel.textAlignment = .right;
        
        self.titleLabel.frame = self.titleLabelRectForBounds(CGRect(origin: CGPoint(x: 10, y: 10), size: self.bounds.size), editing: self.isTitleVisible() || _renderingInInterfaceBuilder)
        self.errorLabel.frame = self.errorLabelRectForBounds(CGRect(origin: CGPoint(x: 10, y: 0), size: self.bounds.size))
        self.lineView.frame = self.lineViewRectForBounds(CGRect(origin: CGPoint(x: 0, y: 10), size: self.bounds.size), editing: self.editingOrSelected || _renderingInInterfaceBuilder)
        
        self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
        
        
        self.titleLabel.text = self.title
    }
    
    override open var intrinsicContentSize: CGSize {
        let height = self.titleHeight() + self.textHeight() + self.errorHeight()
//        //print("height \(height)")
        return CGSize(width: self.bounds.size.width, height: height)
//        return CGSize(width: self.bounds.size.width, height: height)
        
    }
    
    // MARK: - Helpers
    fileprivate func titleOrPlaceholder() -> String? {
        if isEditing && hasSecondHint && self.placeholder != secondHint{
            return secondHint
        } else{
            return "وارد کنید"
        }
    }
    
    // MARK: Left to right support
    var isLeftToRightLanguage = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
        didSet {
            self.updateTextAligment()
        }
    }
    
    fileprivate func updateTextAligment() {
        if (self.isLeftToRightLanguage) {
            self.textAlignment = .left
        } else {
            self.textAlignment = .right
        }
    }
    
    var maxLength: Int = 0
    var minLength: Int = 0
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged(self)
    }
    @objc func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if(maxLength != 0){
            textField.text = String(text.prefix(maxLength))
        }
        
        if (minLength != 0 && textField.text?.count ?? 0 < minLength ) {
            error = textDescription
        }else {
            error = nil
        }
        
    }
    
}

fileprivate extension UITextField {
    // Moves the caret to the correct position by removing the trailing whitespace
    func fixCaretPosition() {
        let beginning = self.beginningOfDocument
        self.selectedTextRange = self.textRange(from: beginning, to: beginning)
        let end = self.endOfDocument
        self.selectedTextRange = self.textRange(from: end, to: end)
    }
}

