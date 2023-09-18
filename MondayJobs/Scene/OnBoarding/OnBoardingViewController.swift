//
//  OnBoardingViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/30/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import paper_onboarding
import RxSwift
import Kingfisher
import CHIPageControl
import SwiftSVG

class OnBoardingViewController: BaseViewController,ViewProtocol {
    
    
    
    @IBOutlet weak var pageControl: CHIPageControlAleppo!
    @IBOutlet weak var onboardingContainer: UIView!
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    @IBOutlet weak var confirmButton: BorderedButton!
    
    @IBOutlet weak var confirmBtnWidthCons: NSLayoutConstraint!
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    var pages: [OnboardingItemInfo]? = [OnboardingItemInfo]()
    var viewModel: OnBoardingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        let onboarding = PaperOnboarding(pageViewBottomConstant: 60)
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        onboardingContainer.addSubview(onboarding)
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: onboardingContainer,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.titleLabel?.font = Fonts.Regular.Regular15()
        confirmButton.backgroundColor = AppColor.orange
        confirmButton.cornerRadius = confirmButton.bounds.height / 2
        confirmButton.setTitle(NSLocalizedString("continue_title", comment: ""), for: .normal)
        
        
        //loginLabel.font = Fonts.Regular.Regular13()
        //loginLabel.textColor = AppColor.black
        //loginLabel.text = NSLocalizedString("login_label", comment: "")
        
       // loginBtn.titleLabel?.font = Fonts.Regular.Regular13()
       // loginBtn.setTitleColor(AppColor.orange, for: .normal)
       // loginBtn.setTitle(NSLocalizedString("login_title", comment: ""), for: .normal)
        
        heightCons.constant = self.view.bounds.height * 2/3
        confirmBtnWidthCons.constant = self.view.bounds.width - 90
        
        pageControl.numberOfPages = 3
        pageControl.radius = 5
        pageControl.tintColor = AppColor.black
        pageControl.currentPageTintColor = AppColor.orange
        pageControl.padding = 6
        pageControl.enableTouchEvents = false
    }
    
    func bindUI() {}
    
    func bindData(){
        assert(viewModel != nil)
        
        let input = OnBoardingViewModel.Input(confirmTrigger: confirmButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        output.confirmAction.drive().disposed(by: disposeBag)
        output.pages.asDriver().do(onNext: { [weak self](items) in
            guard let self = self else {return}
            items.map{ item in
                self.pages?.append( OnboardingItemInfo(informationImage: (UIImage(named: item.imageId!)!),
                                                       title:  item.title ?? "",
                                                       description:item.description ?? "", pageIcon: UIImage(named: "white-bg")!,
                                                       color: UIColor.white,
                                                       titleColor: AppColor.black,
                                                       descriptionColor: AppColor.black,
                                                       titleFont: Fonts.Bold.Bold18(),
                                                       descriptionFont: Fonts.Regular.Regular12()))
                
            }
            
        }).drive().disposed(by: disposeBag)
    }
    
}
extension OnBoardingViewController: PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        self.pageControl.set(progress: index, animated: true)
    }
}
extension OnBoardingViewController: PaperOnboardingDataSource {
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        return (self.pages?[index])!
    }
    
    func onboardingItemsCount() -> Int {
        return self.pages?.count ?? 0
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
