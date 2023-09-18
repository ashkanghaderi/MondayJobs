//
//  TitleTableViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import SkeletonView

class TitleTableViewCell: UITableViewCell,NibLoadableView {
    
    //@IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!{
        didSet{
            secondTitleLabel.isSkeletonable = true
            secondTitleLabel.skeletonCornerRadius = 8
            secondTitleLabel.layer.cornerRadius = 8
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //firstTitleLabel.font = Fonts.Regular.Regular16()
       // firstTitleLabel.textColor = AppColor.black.withAlphaComponent(0.4)
        //firstTitleLabel.text = "27th Online Exhibition"
        
        secondTitleLabel.font = Fonts.Bold.Bold18()
        secondTitleLabel.textColor = AppColor.black
        secondTitleLabel.text =  "Let’s find your job"
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
