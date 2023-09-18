
import UIKit

extension UIFont {
    enum FontStyles {
        case regular(size: CGFloat)
        case bold(size: CGFloat)
        case light(size: CGFloat)
    }
    /// Usage: UIFont.font(with: .regular(size: 16.0))
    static func font(with style: FontStyles) -> UIFont {
        switch style {
        case .regular(let size):
            return UIFont(name: "ProductSans-Regular", size: size)!
            
        case .bold(let size):
            return UIFont(name: "ProductSans-Bold", size: size)!
            
        case .light(let size):
            return UIFont(name: "ProductSans-Light", size: size)!
        }
    }
}
