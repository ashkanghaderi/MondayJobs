//
//  ResultCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/20/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import  Domain

class ResultCell: MaterialTableViewCell,NibLoadableView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewContainerLabel: UILabel!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var companyDesc: UILabel!
    @IBOutlet weak var jobTitles: UILabel!

    var delegate: seaerchResultSelectionDelegate?
    var currentModel: PanelModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.size.width / 2
        imageViewContainerLabel.textColor = UIColor.white
        imageViewContainerLabel.font = Fonts.Bold.Bold20()
        companyLabel.font = Fonts.Regular.Regular15()
        companyDesc.font = Fonts.Regular.Regular12()
        jobTitles.font = Fonts.Regular.Regular14()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        containerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewTapped() {
        delegate?.didSelectResult(model: currentModel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ currentPanel: PanelModel,delegate: seaerchResultSelectionDelegate) {
        companyLabel.text = currentPanel.companyName
        companyDesc.text = currentPanel.companyDesc
        jobTitles.text = currentPanel.jobTitles?.joined(separator: ", ")
        self.delegate = delegate
        self.currentModel = currentPanel
        if let logoUrl = currentPanel.logoUrl, let url = URL(string: BaseURL.dev.rawValue + "/" + logoUrl) {
            self.companyImageView.isHidden = false
            self.companyImageView.kf.setImage(with: url)
            self.imageViewContainer.backgroundColor = UIColor.clear
            self.imageViewContainerLabel.isHidden = true
        } else {
            self.companyImageView.isHidden = true
            self.imageViewContainer.backgroundColor = UIColor.random()
            self.imageViewContainerLabel.isHidden = false
            self.imageViewContainerLabel.text = currentPanel.companyName?.prefix(1).uppercased()
        }
        
    }
    
}
