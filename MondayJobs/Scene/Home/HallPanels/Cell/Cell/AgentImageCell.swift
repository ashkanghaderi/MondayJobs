//
//  AgentImageCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/15/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import Domain

class AgentImageCell: UICollectionViewCell,NibLoadableView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var agentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.masksToBounds = false
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
    }
    
    func bind(imageUrl: String){
        self.agentImageView.image = UIImage(named: "person")
        let urlStr = BaseURL.dev.rawValue + "/\(imageUrl)"
        if let url = URL(string: urlStr ) {
            self.agentImageView.kf.setImage(with: url)
        }
    }

}
