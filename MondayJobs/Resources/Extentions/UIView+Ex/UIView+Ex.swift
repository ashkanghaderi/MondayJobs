
import Foundation
import UIKit
import Lottie

extension UIView {
    
    
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
                       }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
                       },  completion: {(_ completed: Bool) -> Void in
                        self.isHidden = true
                       })
    }
    
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 5, shadowRadius: CGFloat = 5, scale: Bool = true) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = shadowRadius
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    public func removeSubviews(){
        self.subviews.forEach { (item) in
            item.removeFromSuperview()
        }
    }
    
    func calculateRelatedSize(multiplier: CGFloat) -> CGSize {
        return CGSize(width: bounds.size.width * multiplier, height: bounds.size.height * multiplier)
    }
    func calculateRelatedSize(decrease: CGFloat) -> CGSize {
        return CGSize(width: bounds.size.width - decrease, height: bounds.size.height - decrease)
    }
    func calculateRelatedSize(increase: CGFloat) -> CGSize {
        return CGSize(width: bounds.size.width + increase, height: bounds.size.height + increase)
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addGradiant(colors:[CGColor]){
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.colors = colors
        gradiantLayer.frame  = self.frame
        gradiantLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradiantLayer.endPoint   = CGPoint(x: 1.0, y: 1.0)
        gradiantLayer.cornerRadius = self.layer.cornerRadius
        self.layer.addSublayer(gradiantLayer)
    }
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}



//    MARK:Lottie
extension UIView{
    
func showLottie (frame: CGRect? = nil,url:String) {
    var exist = false
    for v in self.subviews {
        if v is AnimationView{
            exist = true
            break
        }
    }
    if !exist,let url = URL(string: url) {
        Animation.loadedFrom(url: url, closure: { [weak self] (animation) in
            if let animation =  animation{
                self?.loadLotiieAfterDownload(animation)
            }
            }, animationCache: nil)
    }
}

private func loadLotiieAfterDownload(_ animation:Animation){
    
    let animationView = AnimationView()
    animationView.loopMode = .loop
    animationView.animation = animation
    self.addSubview(animationView)
    animationView.frame = frame
    animationView.translatesAutoresizingMaskIntoConstraints = false
    animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive       = true
    animationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    animationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive   = true
    animationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive     = true
    
    
    animationView.play(fromProgress: 0,
                       toProgress: 1,
                       loopMode: LottieLoopMode.loop,
                       completion: nil )
    
    
    
}
func stopLottie(){
    
    for v in self.subviews {
        if v is AnimationView{
            v.removeFromSuperview()
        }
    }
}
}

//MARK: - NSConstraint
extension UIView{
    
    func constSetter(_ view: UIView,to parent:UIView, const: CGFloat = 0){
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.topAnchor.constraint(equalTo: view.topAnchor, constant: const).isActive = true
        parent.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: const).isActive = true
        parent.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: const).isActive = true
        parent.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: const).isActive = true
    }
    
    
    
    
    /// attaches all sides of the receiver to its parent view
    func layoutAttachAll(margin : CGFloat = 0.0,top : CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: top)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }
    
    /// attaches the top of the current view to the given view's top if it's a superview of the current view, or to it's bottom if it's not (assuming this is then a sibling view).
    /// if view is not provided, the current view's super view is used
    @discardableResult
    func layoutAttachTop(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: isSuperview ? .top : .bottom,
                                            multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view, attribute: isSuperview ? .bottom : .top,
                                            multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: isSuperview ? .leading : .trailing,
                                            multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: isSuperview ? .trailing : .leading,
                                            multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
}

//MARK: - NIB
extension UIView{
    
    class func fromNib<T: UIView>(nibName:String) -> T? {
         return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? T
     }
    
    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil:nibNameOrNil, type: self)
    }
    
    
    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = String(describing: T.self)
        }
        
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        
        nibViews?.forEach({ (v) in
            if let tog = v as? T {
                view = tog
            }
        })
        
        return view!
    }
    
    public class func nib(nibNameOrNil: String? = nil) -> UINib {
        
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = String(describing: self)
        }
        
        let nib = UINib(nibName: name, bundle: Bundle(for:self))
        
        return nib
    }
    
    @discardableResult
    func fromNib<T : UIView>(topConst:CGFloat = 0.0) -> T? {
        
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll(margin: 0,top: topConst)
        return contentView
    }
    
}

//MARK: - Rotaition

let degreesToRadians = { (angle : CGFloat) in return angle * (CGFloat.pi / 180) }
let radiansToDegrees = { (radian : CGFloat) in return (180 / CGFloat.pi) * radian }

extension UIView{
    
    func rotateView(duration: Double = 1.0, completion: @escaping () -> () = {}) {
           UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
               self.transform = self.transform.rotated(by: CGFloat.pi)
           }) { finished in
               if finished {
                   UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
                       self.transform = self.transform.rotated(by: CGFloat.pi)
                   }) { finished in
                       if finished {
                           completion()
                       }
                   }
               }
           }
       }
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        //rotation.toValue = NSNumber(value: M_PI * 2)
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        //        rotation.repeatCount = FLT_MAX
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotate() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
    func rotate(toAngle : CGFloat, duration : TimeInterval = 0.5) {
        
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotation.toValue = NSNumber(value: Float(degreesToRadians(toAngle)))
        rotation.duration = duration
        
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}

extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
