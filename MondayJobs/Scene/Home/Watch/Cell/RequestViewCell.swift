//
//  RequestViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 12/25/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit

class RequestViewCell: UITableViewCell,NibLoadableView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        caption.font = Fonts.Regular.Regular15()
        caption.textColor = AppColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ viewModel: MenuModel){
        
        self.iconImage.image = UIImage(named: "placeholder")
        if let url = URL(string: viewModel.icon ?? "" ) {
            self.iconImage.kf.setImage(with: url)
        }
        
        caption.text = viewModel.title
        
        statusImage.image = viewModel.isActive == true ? UIImage(named: "status-icon-green") :  UIImage(named: "status-icon-red")
    }
    
}
