

import UIKit
import Kingfisher

extension UIButton{
    /// put image using kingfisher by token
    func load_with_kf(image_id:String,_ options:[KingfisherOptionsInfoItem] = [],placeholder:UIImage? = UIImage(named:"placeholder"),completion:CompletionHandler? = nil){
        if image_id.count > 0 {
            guard let url = URL(string: image_id.forImageURL()) else { return }
            self.kf.setImage(with: url, for: .normal, placeholder:  placeholder, options: [.requestModifier(modifier)]+options, progressBlock: nil, completionHandler: completion)
        }else{
            self.setImage(nil, for: .normal)
        }
    }
    
  
    
}
