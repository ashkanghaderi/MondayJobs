
import Foundation
import UIKit

extension CGFloat{
    
    ///Converts all ranges to 0~1 like: 2~3,4.35~5.55 => 0~1
    func convertRangeTo0_1() -> CGFloat{
        // Convert all ranges to 0 ~ 1 and send for parallex animation
        let mines  = (self).rounded(FloatingPointRoundingRule.down)
        var fixedRange:CGFloat = 0.0
        if mines == self  {
            fixedRange = (self == 0) ? 0:1
        }else{
            fixedRange = self - mines
        }
        return fixedRange
    }
    
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
}
