//
//  SplashViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/24/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SplashViewController: BaseViewController {

    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet weak var retryBtn: BorderedButton!
    @IBOutlet weak var versionLabel: UILabel!

    var viewModel: SplashViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        bindData()
    }
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI(){
      
        self.view.backgroundColor = AppColor.orange
        retryBtn.cornerRadius = retryBtn.bounds.height / 2
        retryBtn.borderColor = AppColor.WhiteTwo
        retryBtn.titleLabel?.font = Fonts.Regular.Regular15()
        retryBtn.borderWidth = 1
        retryBtn.setTitleColor(AppColor.WhiteTwo, for: .normal)
        retryBtn.setTitle(NSLocalizedString("retry_title", comment: ""), for: .normal)
        retryBtn.backgroundColor = UIColor.clear
        
        versionLabel.font = Fonts.Regular.Regular12()
        versionLabel.textColor = AppColor.WhiteTwo
        
    }
    func bindData() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
        .mapToVoid()
        .asDriverOnErrorJustComplete()
        
       
        
        let input = SplashViewModel.Input(retryTrigger: retryBtn.rx.tap.asDriver(), viewWillAppearTrigger: viewWillAppear.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.viewWillAppearAction.drive(),output.retryAction.drive(),output.version.drive(versionLabel.rx.text)
            ,output.isConnected.do(onNext: {
                (status) in
                if status == false {
                    self.ShowSnackBar(snackModel: SnackModel(title: NSLocalizedString("internet_lost", comment: ""), duration: 5))
                }
            }).drive(retryBtn.rx.isHidden),output.error.drive(),output.isFetching.drive()].forEach { (item) in
            item.disposed(by: disposeBag)
        }
    }
    

}
