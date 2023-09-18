
import Foundation
import UIKit

extension CALayer {
    public func removeSublayers(){
        self.sublayers?.forEach({ (item) in
            item.removeFromSuperlayer()
        })
    }
}
