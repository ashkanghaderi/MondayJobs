//
//  HallPanelTableViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/13/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import MaterialComponents
import Domain

class HallPanelTableViewCell: UITableViewCell,NibLoadableView {

    @IBOutlet weak var imageViewContainerLabel: UILabel!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var companyDesc: UILabel!
    @IBOutlet weak var jobTitles: UILabel!
    @IBOutlet weak var jobAgents: UICollectionView!{
        didSet{
            jobAgents.register(AgentImageCell.self)
            jobAgents.dataSource = self
            jobAgents.delegate = self
        }
    }
    @IBOutlet weak var agentsRemain: UILabel!
    var imageDataSource : [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.size.width / 2
        imageViewContainerLabel.font = Fonts.Bold.Bold18()
        self.imageViewContainerLabel.textColor = UIColor.white
        companyLabel.font = Fonts.Regular.Regular15()
        companyLabel.textColor = AppColor.black
        
        companyDesc.font = Fonts.Regular.Regular12()
        companyDesc.textColor = AppColor.black
        companyDesc.alpha = 0.6
        
        jobTitles.font = Fonts.Bold.Bold15()
        jobTitles.textColor = AppColor.black
        
        agentsRemain.font = Fonts.Regular.Regular13()
        agentsRemain.textColor = AppColor.black
        
        dividerView.backgroundColor = AppColor.Steel
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(model: PanelModel){
        companyLabel.text = model.companyName
        companyDesc.text = model.companyDesc
        jobTitles.text = model.jobTitles?.joined(separator: ", ")
        
       // let urlStr = BaseURL.dev.rawValue + "/" + (model.logoUrl ?? "")
        if let logoUrl = model.logoUrl, let url = URL(string: BaseURL.dev.rawValue + "/" + logoUrl) {
            self.companyImageView.isHidden = false
            self.companyImageView.kf.setImage(with: url)
            self.imageViewContainer.backgroundColor = UIColor.clear
            self.imageViewContainerLabel.isHidden = true
        } else {
            self.companyImageView.isHidden = true
            self.imageViewContainer.backgroundColor = UIColor.random()
            self.imageViewContainerLabel.isHidden = false
            self.imageViewContainerLabel.text = model.companyName?.prefix(1).uppercased()
        }
        self.imageDataSource = model.agentImageList ?? []
        agentsRemain.text = self.imageDataSource.count > 3 ? "+ \(self.imageDataSource.count - 3) more agents" : (self.imageDataSource.count == 0 ? "No agent available" : "")
        jobAgents.reloadData()
    }
    
}

extension HallPanelTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return imageDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = jobAgents.dequeueReusableCell(withReuseIdentifier: AgentImageCell.reuseID, for: indexPath) as! AgentImageCell
        cell.layer.zPosition = CGFloat(indexPath.row)
        let model = imageDataSource[indexPath.item]
        cell.bind(imageUrl: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25 , height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
             return -8;
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5;
        }
    
}
