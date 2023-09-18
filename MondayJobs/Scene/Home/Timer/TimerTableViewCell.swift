//
//  TimerTableViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell,NibLoadableView {

    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var timerTitle: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        timerTitle.font = Fonts.Regular.Regular16()
        timerTitle.textColor = AppColor.black.withAlphaComponent(0.4)
        
        timer.font = Fonts.Bold.Bold24()
        timer.textColor = AppColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
