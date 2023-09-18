//
//  jobDescViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/1/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit

class jobDescViewCell: UICollectionViewCell,NibLoadableView {

    @IBOutlet weak var BgView: BorderedView!{
        didSet{
            BgView.isSkeletonable = true
            BgView.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var jobDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        jobDesc.font = Fonts.Regular.Regular15()
        BgView.backgroundColor =  AppColor.Steel
        jobDesc.textColor =  AppColor.Steel_200
    }
    
    override var isSelected: Bool {
        didSet {
            BgView.backgroundColor = isSelected ? AppColor.orange : AppColor.Steel
            jobDesc.textColor = isSelected ? UIColor.white : AppColor.Steel_200
        }
    }
    
    func startLoading(){
        BgView.showAnimatedGradientSkeleton()
    }
    
    func stopLoading(){
        BgView.hideSkeleton()
    }
    
    func bind(_ model: JobItemModel){
        
        jobDesc.text = model.titleEn
        
    }

}
