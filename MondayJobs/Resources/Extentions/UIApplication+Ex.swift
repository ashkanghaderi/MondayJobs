
import Foundation
import UIKit

extension UIApplication {
    /// Get Any ViewController in Topest
    static func topViewController(_ input: UIViewController? = nil) -> UIViewController? {
      var base = input
        
        if base == nil {
            if #available(iOS 13.0, *) {
                 guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate else { return nil}
                base = sceneDelegate.window?.rootViewController
            }else{
                base = UIApplication.shared.delegate?.window??.rootViewController
            }
        }

        if let nav = base as? UINavigationController {
            return topViewController( nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController( selected)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController( presented)
        }
        
        return base
    }
    
    static func rootViewController() -> UIViewController? {
        if #available(iOS 13.0, *) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {return nil}
           return sceneDelegate.window?.rootViewController
        }else{
        return UIApplication.shared.delegate?.window??.rootViewController
        }
        
    }
    
    
}

extension UIApplication {

 static var appVersion: String? {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
 }

}
