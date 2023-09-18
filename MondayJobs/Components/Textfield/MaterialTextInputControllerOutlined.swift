//
//  MaterialTextInputControllerOutlined.swift
//  DigiPay
//
//  Created by Farshad Mousalou on 12/29/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation
import MaterialComponents
import MDFInternationalization
import RxCocoa
import RxSwift
import PureLayout

class MaterialTextInputControllerOutlined: MDCTextInputControllerBase {
    
    private static var __roundedCornersDefault : UIRectCorner = [.allCorners]
    
    fileprivate var _privatePlaceHolderText : String?
    fileprivate var hintPlaceholderLabel : UILabel?
    fileprivate var _isFloatingEnabled : Bool = true
    
    let disposeBag = DisposeBag()
    
    
    override var isFloatingEnabled: Bool {
        get{
             return _isFloatingEnabled
        }
        set{
            _isFloatingEnabled = newValue
            textInput?.layoutIfNeeded()
            textInput?.setNeedsLayout()
        }
    }
    
    override var floatingPlaceholderOffset: UIOffset {
        get{
            var offset = super.floatingPlaceholderOffset
            offset.vertical = 0
            return offset
        }
    }
    
    override var floatingPlaceholderScale: NSNumber! {
        get {
            return NSNumber(value:Float(self.inlinePlaceholderFont.lineHeight / self.textInputFont.lineHeight))
        }
        set{
            
        }
        
    }
    
    override var floatingPlaceholderActiveColor: UIColor! {
        get{
          return self.activeColor
        }
        set{
            self.activeColor = newValue
        }
    }
    
    override var floatingPlaceholderNormalColor: UIColor! {
        get {
            return self.normalColor
        }
        set{
            self.normalColor = newValue
        }
    }
    
    override var placeholderText: String? {
        get{
            return _privatePlaceHolderText
        }
        set{
            _privatePlaceHolderText = newValue
        }
    }
    
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            updateBorder()
        }
    }
    
    var heightScaleFactor : CGFloat = 1.0 {
        didSet {
            updateBorder()
            textInput?.setNeedsDisplay()
            textInput?.setNeedsLayout()
        }
    }
    
    override class var roundedCornersDefault: UIRectCorner {
        get{
            return self.__roundedCornersDefault
        }
        
        set{
            self.__roundedCornersDefault = newValue
        }
    }
    
    private var fontHeight: CGFloat {
        guard let textInput = self.textInput else {
            return 0
        }
        
        return max(textInput.font!.lineHeight,textInput.placeholderLabel.font.lineHeight)
    }
    
    private var placeHolderCenterY : NSLayoutConstraint!
    private var placeholderLeading : NSLayoutConstraint!
    
    deinit {
        self.hintPlaceholderLabel?.isHidden = true
        self.hintPlaceholderLabel = nil
        self.textInput?.underline?.isHidden = false
        self.textInput?.borderView?.borderStrokeColor = nil
        
        self.textInput = nil
    }
    
    
    override init() {
        super.init()
        self.observerMethods()
    }
    
    private typealias InputType = UIView & MDCTextInput
    
    required init(textInput input: (UIView & MDCTextInput)?) {
        super.init(textInput: input)
        input?.textInsetsMode = .always
        input?.underline?.isHidden = true
    }
    
    //MARK: - MDCTextInputPositioningDelegate
    override func leadingViewRect(forBounds bounds: CGRect, defaultRect: CGRect) -> CGRect {
        
        guard let textInput = self.textInput as? UITextField & MDCTextInput else {
            return super.leadingViewRect(forBounds: bounds, defaultRect: defaultRect)
        }
        
        var leadingRect = defaultRect
        let padding : CGFloat = 16
        let offsetX : CGFloat = textInput.mdf_effectiveUserInterfaceLayoutDirection == .leftToRight ? padding : -1.0 * padding
        
        leadingRect = leadingRect.offsetBy(dx: offsetX, dy: 0)
        
        let borderRect = self.borderRect(forInput: textInput)
        
        leadingRect.origin.y = borderRect.minY + borderRect.height / 2 + leadingRect.height / 2
        return leadingRect
    }
    
    override func leadingViewTrailingPaddingConstant() -> CGFloat {
        return 16
    }
    
    override func trailingViewTrailingPaddingConstant() -> CGFloat {
        return 12
    }
    
    override func trailingViewRect(forBounds bounds: CGRect, defaultRect: CGRect) -> CGRect {
        
        guard let textInput = self.textInput else {
            return super.trailingViewRect(forBounds: bounds, defaultRect: defaultRect)
        }
        
        var trailingRect = defaultRect
        let padding : CGFloat = 12
        let offsetX : CGFloat = textInput.mdf_effectiveUserInterfaceLayoutDirection == .rightToLeft ? padding : -1.0 * padding
        
        trailingRect = trailingRect.offsetBy(dx: offsetX, dy: 0)
        
        let borderRect = self.borderRect(forInput: textInput)
        
        trailingRect.origin.y = borderRect.minY + borderRect.height / 2 + trailingRect.height / 2
        return trailingRect
    }
    
    override func textInsets(_ defaultInsets: UIEdgeInsets) -> UIEdgeInsets {
        guard let textInput = textInput else {
            return super.textInsets(defaultInsets)
        }
        
        var textInsets: UIEdgeInsets = super.textInsets(defaultInsets)
        let textVerticalOffset = fontHeight * CGFloat(0.5) + 4.0
        
        let scale: CGFloat = UIScreen.main.scale
        let placeholderEstimatedHeight: CGFloat = ceil(fontHeight * scale) / scale
        textInsets.top = CGFloat(self.borderHeight(for: textInput) - 16) - placeholderEstimatedHeight + textVerticalOffset
        
        textInsets.left = CGFloat(16)
        textInsets.right = CGFloat(16)
        
        return textInsets
        
    }
    
    override func textInputDidLayoutSubviews() {
        super.textInputDidLayoutSubviews()
        
        if let textInput = textInput as? UITextField & MDCTextInput {
            let textframe = textInput.textRect(forBounds: self.borderRect(forInput: textInput))
            var leadingUnderlineFrame = textInput.leadingUnderlineLabel.frame
            leadingUnderlineFrame.origin.y = textframe.origin.y + textframe.height
            textInput.leadingUnderlineLabel.frame = leadingUnderlineFrame
            
            var trailingUnderlineLabelFrame = textInput.trailingUnderlineLabel.frame
            trailingUnderlineLabelFrame.origin.y = textframe.origin.y + textframe.height
            
            textInput.trailingUnderlineLabel.frame = trailingUnderlineLabelFrame
            
        }
        
    }
    
   
    
}

extension MaterialTextInputControllerOutlined {
    
    private func observerMethods () {
        
        self.rx.methodInvoked(Selector(("updateBorder")))
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: {[weak self] (values) in
            self?.updateBorder()
        }).disposed(by: disposeBag)
        
        self.rx.methodInvoked(Selector(("updatePlaceholder")))
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: {[weak self] (values) in
                self?.updatePlaceholder()
            }).disposed(by: disposeBag)
        
        self.rx.methodInvoked(Selector(("updateLayout")))
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: {[weak self] (values) in
               self?.updateLayouts()
            }).disposed(by: disposeBag)
        
        
    }
    
    private func updateLayouts(){
        
        self.textInput?.clipsToBounds = false
        self.textInput?.underline?.isHidden = true
        self.hintPlaceholderLabel?.textAlignment = (textInput as? MDCTextField)?.textAlignment ?? .natural
    }
    
    private func updateBorder() {
        
        if let textInput = textInput as? UITextField & MDCTextInput {
            
            let size = CGSize(width: self.cornerRadius, height: self.cornerRadius)
            var rect = self.borderRect(forInput: textInput)
            rect.size.height *= self.heightScaleFactor
            
            var path = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: self.roundedCorners,
                                    cornerRadii: size)
            
            if ((textInput as MDCTextInput).isEditing || (textInput as UITextField).text.isEmptyOrBlank == false) && isFloatingEnabled{
                
                var placeholderWidth = textInput.placeholderLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    .width * CGFloat(self.floatingPlaceholderScale.floatValue)
                
                placeholderWidth += 8
                
                path = roundedPath(from: rect,
                                   withTextSpace: placeholderWidth,
                                   leadingOffset: 16.0 - 8.0 / 2,
                                   textInput: textInput)
            }
            
            textInput.borderPath = path
            
            
            if self.hintPlaceholderLabel == nil,
                let textInput = self.textInput as? UITextField & MDCTextInput {
                
                for case let placeHolderLabel as UILabel in textInput.subviews
                    where placeHolderLabel != textInput.placeholderLabel &&
                        placeHolderLabel != textInput.leadingUnderlineLabel &&
                        placeHolderLabel !== textInput.trailingUnderlineLabel {
                            
                            self.hintPlaceholderLabel = placeHolderLabel
                            self.hintPlaceholderLabel?.adjustsFontSizeToFitWidth = true
                            self.hintPlaceholderLabel?.isHidden = false
                            placeHolderLabel.textColor = self.leadingUnderlineLabelTextColor
                            self.hintPlaceholderLabel?.alpha = 0.0
                }
            }
            
            var borderColor = (textInput as MDCTextInput).isEditing ? self.activeColor : self.normalColor
            
            if !(textInput as MDCTextInput).isEnabled {
                borderColor = self.disabledColor
            }
            
            textInput.borderView?.borderStrokeColor = self.errorText != nil ? self.errorColor : borderColor
            
            textInput.borderView?.borderPath?.lineWidth = (textInput as MDCTextInput).isEditing ? 2 : 1;
            
            textInput.borderView?.setNeedsLayout()
            
            
            
            _ = self.perform(Selector(("updatePlaceholder")))
            textInput.placeholderLabel.textColor = textInput.borderView?.borderStrokeColor
            
            let shouldHideHintPlaceholder = !((textInput as MDCTextInput).isEditing && (textInput as MDCTextInput).text.isEmptyOrBlank)
            UIView.animate(withDuration: shouldHideHintPlaceholder ? 0.2 : 0.4,
                           delay: 0.0,
                           options: [.beginFromCurrentState],
                           animations: { [weak self] in
                            
                            if shouldHideHintPlaceholder {
                                self?.hintPlaceholderLabel?.alpha = 0.0
                            }else {
                                self?.hintPlaceholderLabel?.alpha = CGFloat(self?.floatingPlaceholderScale.floatValue ?? 0)
                            }
                            
            }){ _ in
                
            }
            
            self.hintPlaceholderLabel?.frame = textInput.textRect(forBounds: self.borderRect(forInput: textInput))
            self.hintPlaceholderLabel?.text = self._privatePlaceHolderText
            self.hintPlaceholderLabel?.textColor = self.leadingUnderlineLabelTextColor
            if let materialTxtField = textInput as? MaterialTextField {
                self.hintPlaceholderLabel?.textColor = materialTxtField.hintPlaceholderTextColor
            }
            
            if let textInput = (textInput as? MDCTextField), let leadingView = textInput.leadingView {
                var center = leadingView.center
                center.y = borderRect(forInput: textInput).midY
                leadingView.center = center
            }
            
            if let textInput = (textInput as? MDCTextField), let trailingView = textInput.trailingView {
                var center = trailingView.center
                center.y = borderRect(forInput: textInput).midY
                trailingView.center = center
            }
        }
        
    }
    
    private func updatePlaceholder() {
        
        guard let textInput = self.textInput else {
             return
        }
        
        let scale = UIScreen.main.scale
        let placeHolderEstimatedHeight = ceil(fontHeight * scale) / scale
        let placeHolderConstant = (self.borderHeight(for: textInput) / 2) - (placeHolderEstimatedHeight / 2)
            + fontHeight * 0.5
        
        if self.placeHolderCenterY == nil {
            placeHolderCenterY = textInput.placeholderLabel.topAnchor.constraint(equalTo: textInput.topAnchor,
                                                                constant: placeHolderConstant)
            placeHolderCenterY.priority = .defaultHigh
            placeHolderCenterY.isActive = true
            textInput.placeholderLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh + 1,
                                                                 for: .vertical)
        }
        
        self.placeHolderCenterY.constant = placeHolderConstant
        
        var placeholderLeadingConstant : CGFloat = 16;
        
        if let leadingViewInput = textInput as? MDCLeadingViewTextInput,
            let leadingView = leadingViewInput.leadingView,
            leadingView.superview != nil {
            placeholderLeadingConstant += leadingView.frame.width + self.leadingViewTrailingPaddingConstant()
        }
        
        if self.placeholderLeading == nil {
            self.placeholderLeading = textInput.placeholderLabel
                .leadingAnchor
                .constraint(equalTo: textInput.leadingAnchor,
                            constant: placeholderLeadingConstant)
            
            self.placeholderLeading.priority = .defaultHigh
            self.placeholderLeading.isActive = true
            
        }
        
        self.placeholderLeading.constant = placeholderLeadingConstant;
        
        textInput.placeholderLabel.autoPinEdge(toSuperviewMargin: .trailing, relation: .greaterThanOrEqual)
    }
    
    private func borderRect(forInput input : InputType) -> CGRect {
        var rect = input.bounds
        rect.origin.y = rect.origin.y + fontHeight * 0.5
        rect.size.height = self.borderHeight(for: input)
        return rect
    }
    
    private func borderHeight(for input : InputType) -> CGFloat {
        let scale: CGFloat = UIScreen.main.scale
        let placeHolderEstimatedHeight = ceil(fontHeight * scale) / scale
        return placeHolderEstimatedHeight + 21
    }
    
    private func roundedPath(from f: CGRect,
                             withTextSpace textSpace: CGFloat,
                             leadingOffset offset: CGFloat,
                             textInput : InputType) -> UIBezierPath {
        
        let path = UIBezierPath()
        let radius = self.cornerRadius
        let yOffset: CGFloat = f.origin.y
        let xOffset: CGFloat = f.origin.x
        
        // Draw the path
        path.move(to: CGPoint(x: radius + xOffset, y: yOffset))
        if textInput.mdf_effectiveUserInterfaceLayoutDirection == .leftToRight {
            path.addLine(to: CGPoint(x: offset + xOffset, y: yOffset))
            path.move(to: CGPoint(x: textSpace + offset + xOffset, y: yOffset))
            path.addLine(to: CGPoint(x: f.size.width - radius + xOffset, y: yOffset))
        } else {
            path.addLine(to: CGPoint(x: xOffset + (f.size.width - (offset + textSpace)), y: yOffset))
            path.move(to: CGPoint(x: xOffset + (f.size.width - offset), y: yOffset))
            path.addLine(to: CGPoint(x: xOffset + (f.size.width - radius), y: yOffset))
        }
        
        path.addArc(withCenter: CGPoint(x: f.size.width - radius + xOffset, y: radius + yOffset),
                    radius: radius,
                    startAngle: -CGFloat(CGFloat.pi / 2),
                    endAngle: 0,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: f.size.width + xOffset, y: f.size.height - radius + yOffset))
        path.addArc(withCenter: CGPoint(x: f.size.width - radius + xOffset,
                                        y: f.size.height - radius + yOffset),
                    radius: radius,
                    startAngle: 0, endAngle: -CGFloat((CGFloat.pi * 3) / 2),
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: radius + xOffset, y: f.size.height + yOffset))
        path.addArc(withCenter: CGPoint(x: radius + xOffset, y: f.size.height - radius + yOffset),
                    radius: radius,
                    startAngle: -CGFloat((CGFloat.pi * 3) / 2),
                    endAngle: -CGFloat(CGFloat.pi), clockwise: true)
        
        path.addLine(to: CGPoint(x: xOffset, y: radius + yOffset))
        
        path.addArc(withCenter: CGPoint(x: radius + xOffset, y: radius + yOffset),
                    radius: radius,
                    startAngle: -CGFloat(CGFloat.pi), endAngle: -CGFloat(CGFloat.pi / 2), clockwise: true)
        
        return path
    }
}
