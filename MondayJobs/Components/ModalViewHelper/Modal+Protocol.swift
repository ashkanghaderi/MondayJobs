
import Foundation
import UIKit

protocol Modal {
    func show(animated:Bool,place: CGPoint?)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
    var backgroundShadow: UIColor { get set }
    var timeInterval: Double? {set get }
}

extension Modal where Self: UIView {
    func show(animated:Bool,place: CGPoint?){
        DispatchQueue.main.async {
            self.backgroundView.alpha = 0
            if let topController = UIApplication.topViewController() {
                self.dialogView.center = CGPoint(x: topController.view.center.x, y: topController.view.bounds.height + 250)
                topController.view.addSubview(self)
            }
            if animated {
                
                UIView.animate(withDuration: 0.33, animations: {
                    self.backgroundView.alpha = 0.5
                })
                
                UIView.animate(withDuration: 0.33, delay: 0, options: .transitionCurlDown, animations: {
                    if let mode = place {
                        self.dialogView.center  = mode
                    }else{
                        self.dialogView.center  = self.center
                    }
                }, completion: nil)
            }else{
                self.backgroundView.alpha = 0.5
                self.dialogView.center  = self.center
            }
            if let time = self.timeInterval {
                self.dismissWithDuration(time)
            }
        }
    }
    
    func dismissWithDuration(_ value: Double){
        DispatchQueue.main.asyncAfter(deadline: .now() + value , execute: {
            self.dismiss(animated: true)
        })
    }
    
    func dismiss(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in
                
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
        
    }
}
