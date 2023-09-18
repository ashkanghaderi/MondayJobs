//
//  ConfirmViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 2/16/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa
import Domain
import NetworkPlatform

class ConfirmViewController: BaseViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alreadyConfirmBtn: UIButton!
    @IBOutlet weak var headerHeightCons: NSLayoutConstraint!
    
    var viewModel: ConfirmViewModel!
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI(){
        
        headerView.layer.cornerRadius = 12
        titleLabel.font = Fonts.Regular.Regular16()
        let email = AuthorizationInfo.get(by: "email")
        titleLabel.text = "We've sent an email to \(email!). Open it up to activate your account."
        
        alreadyConfirmBtn.setTitleColor(UIColor.white, for: .normal)
        alreadyConfirmBtn.layer.cornerRadius = 12
        alreadyConfirmBtn.backgroundColor = AppColor.orange
        alreadyConfirmBtn.titleLabel?.font = Fonts.Regular.Regular15()
        alreadyConfirmBtn.setTitle("Already Activated?")
        
        headerView.backgroundColor = AppColor.orange
        headerHeightCons.constant = self.view.bounds.height / 3
        
        let logo = UIView(SVGNamed: "logo-whiteSVG")
        logoView.addSubview(logo)
        
        animationView = .init(name: "unlocked")
        animationView!.frame = lottieView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 0.5
        lottieView.addSubview(animationView!)
        
        
    }


    func bindData() {
        
        let input = ConfirmViewModel.Input(confirmTestTrigger: alreadyConfirmBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.isActive.drive(ActivationBinding),
         output.error.drive(errorBinding),output.isFetching.drive(fetchingBinding)].forEach { (item) in
            item.disposed(by: disposeBag)
         }
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            if let eError = error as? EliniumError{
                vc.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
            }
        })
    }
    
    var ActivationBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, isActive) in
           
            if isActive == true {
                self.animationView!.play(completion: {_ in 
                    self.viewModel.navigator.toHome()
                })
            } else {
                vc.ShowSnackBar(snackModel: SnackModel(title: "Still not activated!" , duration: 5))
            }
        })
    }
    
    var fetchingBinding: Binder<Bool> {
        return Binder(self, binding: { (vc, status) in
            
            if status == true {
                vc.startAnimation()
            } else {
                vc.stopAnimation()
            }
        })
    }
}
