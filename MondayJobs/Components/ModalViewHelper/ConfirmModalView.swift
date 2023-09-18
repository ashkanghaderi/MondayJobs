//
//  TACView.swift
//  DigiPay
//
//  Created by Amirhesam Rayatnia on 2018-08-03.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit
import WebKit
class ConfirmModalView: UIView, Modal {
    var backgroundShadow: UIColor = .black
    var timeInterval: Double? = nil
    var backgroundView = UIView()
    var dialogView = UIView()
    
    
    convenience init(title:String,view:UIView) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, view: view)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(title:String, view:UIView){
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = backgroundShadow
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 30))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "IRANYekan(FaNum)", size: 14)
        titleLabel.textColor = AppColor.textfieldBorderColor
        dialogView.addSubview(titleLabel)
        
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 16)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(separatorLineView)
        
        
        
        view.frame.origin = CGPoint(x: 8, y: separatorLineView.frame.height + separatorLineView.frame.origin.y + 8)
        view.frame.size = CGSize(width: dialogViewWidth - 16 , height: dialogViewWidth - 16)
//        let url = URL(string: "http://dev:8080/digipay/api/v1/files/tac")
//        textView.load(URLRequest(url: url!))
//        textView.layer.cornerRadius = 4
//        textView.clipsToBounds = true
        dialogView.addSubview(view)
        
        let dialogViewHeight = titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + view.frame.height + 8
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
}
