//
//  MenuViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 12/24/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import Domain
import SkeletonView

class MenuViewCell: UITableViewCell,NibLoadableView {

    @IBOutlet weak var imageViewContainerLabel: UILabel!
    @IBOutlet weak var imageViewContainer: UIView!{
        didSet{
            imageViewContainer.isSkeletonable = true
            imageViewContainer.skeletonCornerRadius  = Float(imageViewContainer.frame.size.width / 2)
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var caption: UILabel!{
        didSet{
            caption.isSkeletonable = true
            caption.layer.cornerRadius  = 7
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        caption.font = Fonts.Regular.Regular17()
        caption.textColor = AppColor.black
        imageViewContainerLabel.font = Fonts.Bold.Bold24()
        imageViewContainerLabel.textColor = UIColor.white
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ viewModel: WatchModel){
        
        if let logoUrl = viewModel.logoUrl, let url = URL(string: BaseURL.dev.rawValue + "/" + logoUrl) {
            self.iconImageView.isHidden = false
            self.iconImageView.kf.setImage(with: url)
            self.imageViewContainer.backgroundColor = UIColor.clear
            self.imageViewContainerLabel.isHidden = true
        } else {
            self.iconImageView.isHidden = true
            self.imageViewContainer.backgroundColor = UIColor.random()
            self.imageViewContainerLabel.isHidden = false
            self.imageViewContainerLabel.text = viewModel.companyName?.prefix(1).uppercased()
        }
        
        caption.text = viewModel.companyName
    }
    
}
