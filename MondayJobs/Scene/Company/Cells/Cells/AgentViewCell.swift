//
//  AgentViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/1/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import Domain

class AgentViewCell: UITableViewCell,NibLoadableView {

    @IBOutlet weak var imageContainerTilte: UILabel!
    @IBOutlet weak var imageContainer: UIView!{
        didSet{
            imageContainer.isSkeletonable = true
            imageContainer.skeletonCornerRadius  = Float(imageContainer.frame.size.width / 2)
        }
    }
    @IBOutlet weak var agentImage: UIImageView!
    @IBOutlet weak var agentName: UILabel!{
        didSet{
            agentName.isSkeletonable = true
            agentName.layer.cornerRadius = 12
            agentName.font = Fonts.Regular.Regular16()
        }
    }
    @IBOutlet weak var agentPosition: UILabel!{
        didSet{
            agentPosition.isSkeletonable = true
            agentPosition.layer.cornerRadius = 12
            agentPosition.font = Fonts.Regular.Regular12()
            agentPosition.textColor = AppColor.black.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var callAgentBtn: UIButton!{
        didSet{
            callAgentBtn.isSkeletonable = true
            callAgentBtn.skeletonCornerRadius = Float(callAgentBtn.frame.size.width / 2)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startLoading(){
        [imageContainer,agentName,agentPosition,callAgentBtn].forEach({$0?.showAnimatedGradientSkeleton()})
    }
    
    func stopLoading(){
        [imageContainer,agentName,agentPosition,callAgentBtn].forEach({$0?.hideSkeleton()})
    }
    
    func bind(_ model: AgentModel){
        //let urlStr = BaseURL.dev.rawValue + "/" + (model.avatarUrl ?? "")
        if let avatarUrl = model.avatarUrl, let url = URL(string: BaseURL.dev.rawValue + "/" + avatarUrl) {
            self.agentImage.isHidden = false
            self.agentImage.kf.setImage(with: url)
            self.imageContainer.backgroundColor = UIColor.clear
            self.imageContainerTilte.isHidden = true
        } else {
            self.agentImage.isHidden = true
            self.imageContainer.backgroundColor = UIColor.random()
            self.imageContainerTilte.isHidden = false
            self.imageContainerTilte.text = model.name?.prefix(1).uppercased()
        }
        
        agentName.text = model.name ?? ""
        agentPosition.text = model.position ?? ""
        
        
    }
    
}
