//
//  SuggesstionViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/14/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import Kingfisher
import MaterialComponents

class SuggesstionViewCell: UICollectionViewCell, NibLoadableView {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companayDesc: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var salary: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 16
        
        companyName.font = Fonts.Regular.Regular15()
        companyName.textColor = AppColor.black
        
        companayDesc.font = Fonts.Regular.Regular12()
        companayDesc.textColor = AppColor.black
        companayDesc.alpha = 0.6
        
        jobTitle.font = Fonts.Bold.Bold16()
        jobTitle.textColor = AppColor.black
        
        salary.font = Fonts.Regular.Regular14()
        salary.textColor = AppColor.black
    }
    
    func bind(model: SuggesstionModel){
        self.logoImageView.image = UIImage(named: "person")
        if let url = URL(string: model.icon ?? "" ) {
            self.logoImageView.kf.setImage(with: url)
        }
        
        companyName.text = model.companyName
        companayDesc.text = model.companyDesc
        jobTitle.text = model.jobTitle
        salary.text = model.salary
    }

}
