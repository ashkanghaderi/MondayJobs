//
//  CompanyMenuViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/19/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NetworkPlatform
import Domain
import SkeletonView

class CompanyMenuViewController: BaseViewController {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 14
        }
    }
    @IBOutlet weak var addToWatchBtn: BorderedButton!{
        didSet{
            addToWatchBtn.titleLabel?.font = Fonts.Bold.Bold16()
            addToWatchBtn.setTitleColor(AppColor.orange, for: .normal)
            addToWatchBtn.borderColor = AppColor.orange
            addToWatchBtn.isSkeletonable = true
            addToWatchBtn.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var reportBtn: BorderedButton!{
        didSet{
            reportBtn.titleLabel?.font = Fonts.Bold.Bold16()
            reportBtn.setTitleColor(AppColor.orange, for: .normal)
            reportBtn.borderColor = AppColor.orange
            reportBtn.isSkeletonable = true
            reportBtn.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var removeFromWatchBtn: BorderedButton!{
        didSet{
            removeFromWatchBtn.titleLabel?.font = Fonts.Bold.Bold16()
            removeFromWatchBtn.setTitleColor(AppColor.orange, for: .normal)
            removeFromWatchBtn.borderColor = AppColor.orange
            removeFromWatchBtn.isSkeletonable = true
            removeFromWatchBtn.skeletonCornerRadius = 12
        }
    }
    
    var viewModel: CompanyMenuViewModel!
    public var didTapBlur = PublishSubject<Void>()
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.sizeToFit()
        containerView.layoutIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        blurView.addGestureRecognizer(tap)
        
        bindViewModel()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        didTapBlur.onNext(())
    }

    private func startSkeletonAnimation(){
        
        
        [addToWatchBtn,
         reportBtn,
         removeFromWatchBtn
         ].forEach({$0?.showAnimatedGradientSkeleton()})
    }
    
    private func stopSkeletonAnimation(){
        
        [addToWatchBtn,
         reportBtn,
         removeFromWatchBtn
         ].forEach({$0?.hideSkeleton()})
        
    }

    private func bindViewModel() {
        assert(viewModel != nil)
        
        let input = CompanyMenuViewModel.Input(addToWatchTrigger: addToWatchBtn.rx.tap.asDriver(), removeFromWatchTrigger: removeFromWatchBtn.rx.tap.asDriver(), reportTrigger: reportBtn.rx.tap.asDriver(), dismissTrigger: self.rx.didTap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.addToWatchAction.drive().disposed(by: disposeBag)
        output.removeFromWatchAction.drive().disposed(by: disposeBag)
        output.reportAction.drive().disposed(by: disposeBag)
        output.dismissAction
            .drive()
            .disposed(by: disposeBag)
        output.isFetching
            .drive(fetchingBinding)
            .disposed(by: disposeBag)
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)

    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            if let eError = error as? EliniumError{
                vc.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
            }
        })
    }
    
    var fetchingBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, status) in
            
            if status == true {
                vc.startSkeletonAnimation()
            } else {
                vc.stopSkeletonAnimation()
            }
        })
    }

}

extension Reactive where Base: CompanyMenuViewController {
    

    internal var didTap: ControlEvent<Void> {
        
        return ControlEvent(events: self.base.didTapBlur)
        
    }
}
