//
//  Utility.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/4/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import UIKit
import SHSearchBar

class Utility {
    
    static func startIndicatorAnimation() {
        DispatchQueue.main.async {
            let activityData = ActivityData(type: .lineScalePulseOutRapid,
                                            color: AppColor.orange,
                                            backgroundColor : UIColor.black.withAlphaComponent(0.2))
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        }
    }
    
    static func stopIndicatorAnimation() {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
    
    static func defaultSearchBar(withRasterSize rasterSize: CGFloat,
                          leftView: UIView?,
                          rightView: UIView?,
                          delegate: SHSearchBarDelegate,
                          useCancelButton: Bool = true) -> SHSearchBar {

        var config = defaultSearchBarConfig(rasterSize)
        config.leftView = leftView
        config.rightView = rightView
        config.useCancelButton = useCancelButton

        if leftView != nil {
            config.leftViewMode = .always
        }

        if rightView != nil {
            config.rightViewMode = .unlessEditing
        }

        let bar = SHSearchBar(config: config)
        bar.delegate = delegate
        bar.placeholder = NSLocalizedString("sbe.textfieldPlaceholder.default", comment: "")
        bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 3)
        bar.layer.shadowRadius = 5
        bar.layer.shadowOpacity = 0.25
        return bar
    }

    static func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
        var config: SHSearchBarConfig = SHSearchBarConfig()
        config.rasterSize = rasterSize
    //    config.cancelButtonTitle = NSLocalizedString("sbe.general.cancel", comment: "")
        config.cancelButtonTextAttributes = [.foregroundColor: UIColor.darkGray]
        config.textContentType = UITextContentType.fullStreetAddress.rawValue
        config.textAttributes = [.foregroundColor: UIColor.gray]
        return config
    }

    static func imageViewWithIcon(_ icon: UIImage, raster: CGFloat) -> UIView {
        let imgView = UIImageView(image: icon)
        imgView.translatesAutoresizingMaskIntoConstraints = false

        imgView.contentMode = .center
        imgView.tintColor = UIColor(red: 0.75, green: 0, blue: 0, alpha: 1)

        let container = UIView()
        container.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: raster, bottom: 0, trailing: raster)
        container.addSubview(imgView)

        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor)
        ])

        return container
    }

}

protocol IndicatorProtocol
{
    func startAnimation();
    func stopAnimation();
}


extension IndicatorProtocol
{
    func startAnimation()
    {
        Utility.startIndicatorAnimation()
    }
    
    func stopAnimation()
    {
        Utility.stopIndicatorAnimation()
    }
}
