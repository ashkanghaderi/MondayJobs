

import Foundation
import Kingfisher

extension UIImageView {
    
    func load_with_kf(image_id:String,_ options:[KingfisherOptionsInfoItem] = [],placeholder:UIImage? = UIImage(named:"placeholder"),completion:CompletionHandler? = nil){
        if image_id.count > 0 {
        guard let url = URL(string: image_id.forImageURL()) else { return }
        self.kf.setImage(with: url, placeholder:  placeholder, options: [.requestModifier(modifier)]+options, progressBlock: nil, completionHandler: completion)
        }else{
            self.image = nil
        }}
    
    func load_with_kf_without_placeholder(image_id:String,_ options:[KingfisherOptionsInfoItem] = [],placeholder:UIImage? = UIImage(named:"")){
        guard let url = URL(string:image_id.forImageURL()) else { return }
        self.kf.setImage(with: url, placeholder:  placeholder, options: [.requestModifier(modifier)]+options)
    }
    
    func load_bank_with_kf(image_id:String,_ options:[KingfisherOptionsInfoItem] = [],placeholder:UIImage? = UIImage(named:"bank-placeholder")){
        guard let url = URL(string: image_id.forImageURL()) else { return }
        self.kf.setImage(with: url, placeholder:  placeholder, options: [.requestModifier(modifier)]+options)
    }
    
    
}


