//
//  DescTableViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/8/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import SkeletonView

class DescTableViewCell: UITableViewCell,NibLoadableView  {

    @IBOutlet weak var jobDescTitle: UILabel!{
        didSet{
            jobDescTitle.isSkeletonable = true
            jobDescTitle.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.isSkeletonable = true
            textView.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var viewMoreStackView: UIStackView!{
        didSet{
            viewMoreStackView.isSkeletonable = true
            viewMoreStackView.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var viewMoreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        jobDescTitle.textColor = AppColor.Steel_300
        jobDescTitle.font = Fonts.Regular.Regular12()
        viewMoreBtn.setTitleColor(AppColor.Steel_300, for: .normal)
        viewMoreBtn.titleLabel?.font = Fonts.Regular.Regular12()
        textView.font = Fonts.Regular.Regular15()
    }
    
    func bind(_ desc: String){
        textView.text = desc
    }
    
    func startLoading(){
        [jobDescTitle,textView,viewMoreStackView].forEach({$0?.showAnimatedGradientSkeleton()})
    }
    
    func stopLoading(){
        [jobDescTitle,textView,viewMoreStackView].forEach({$0?.hideSkeleton()})
    }
    
    @IBAction func onViewMoreDesc(_ sender: Any) {
    }
}
