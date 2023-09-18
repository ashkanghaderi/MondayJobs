//
//  ExtraInfoViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/2/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Domain

class ExtraInfoViewController: BaseViewController {
    
    
    @IBOutlet weak var headerView: BorderedView!
    @IBOutlet weak var personNamelabel: UILabel!
    @IBOutlet weak var imageContainerView: BorderedView!
    @IBOutlet weak var headerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var registerWidthCons: NSLayoutConstraint!
    @IBOutlet weak var jobTextView: MaterialTextField!
    @IBOutlet weak var workPermitBtn: CheckBox!
    @IBOutlet weak var workPermitLabel: UILabel!
    @IBOutlet weak var tasBtn: CheckBox!
    @IBOutlet weak var tasLabel: UILabel!
    @IBOutlet weak var tasSegueBtn: UIButton!
    @IBOutlet weak var registerBtn: BorderedButton!
    
    var viewModel: ExtraInfoViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI(){
        
        
        jobTextView.sizeToFit()
        jobTextView.borderColor = AppColor.Steel
        jobTextView.font = Fonts.Regular.Regular16()
        jobTextView.textContentType = .jobTitle
        jobTextView.activeColor = AppColor.black
        jobTextView.normalColor = AppColor.black
        (jobTextView.controller as? MaterialTextInputControllerOutlined)?.cornerRadius = 12
        jobTextView.placeholder = NSLocalizedString("register_job", comment: "")
        jobTextView.autocorrectionType = .no
        
        workPermitLabel.font = Fonts.Regular.Regular13()
        workPermitLabel.textColor = AppColor.black
        workPermitLabel.text = NSLocalizedString("work_permit_label", comment: "")
        
        tasLabel.font = Fonts.Regular.Regular13()
        tasLabel.textColor = AppColor.black
        tasLabel.text = NSLocalizedString("tas_label", comment: "")
        
        tasSegueBtn.titleLabel?.font = Fonts.Regular.Regular13()
        tasSegueBtn.setTitleColor(AppColor.orange, for: .normal)
        
        let attrs = [
            NSAttributedString.Key.font : Fonts.Regular.Regular13(),
            NSAttributedString.Key.foregroundColor : AppColor.orange,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:NSLocalizedString("tas_segue_label", comment: ""), attributes:attrs)
        attributedString.append(buttonTitleStr)
        tasSegueBtn.setAttributedTitle(attributedString, for: .normal)
        
        registerBtn.setTitleColor(UIColor.white, for: .normal)
        registerBtn.titleLabel?.font = Fonts.Regular.Regular15()
        registerBtn.backgroundColor = UIColor.white
        registerBtn.cornerRadius = registerBtn.bounds.height / 2
        registerBtn.setTitle(NSLocalizedString("register_title", comment: ""), for: .normal)
        registerWidthCons.constant = self.view.bounds.width - 150
        
        headerView.backgroundColor = AppColor.orange
        headerHeightCons.constant = self.view.bounds.height / 3 + 35
        
        imageContainerView.cornerRadius = imageContainerView.bounds.height/2
        imageContainerView.borderColor = AppColor.orange
        imageContainerView.borderWidth = 3
        
        
        personNamelabel.font = Fonts.Regular.Regular16()
        personNamelabel.textColor = UIColor.white
    }
    
    func bindData() {
        let input = ExtraInfoViewModel.Input(registerTrigger: registerBtn.rx.tap.asDriver(),   workPermitTrigger: workPermitBtn.rx.tap.asDriver(), TASTrigger: tasBtn.rx.tap.asDriver(),TASSegueTrigger: tasSegueBtn.rx.tap.asDriver(),  job: jobTextView.rx.text.orEmpty.debounce(.milliseconds(1000), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete().asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.registerAction.drive(),output.workPermitAction.drive(),output.TASAction.drive(),output.TASSegueAction.drive(),output.canRegister.do(onNext:{(status) in
            self.registerBtn.isEnabled = status
            if status == false {
                
                self.registerBtn.setTitleColor(AppColor.orange, for: .disabled)
                self.registerBtn.backgroundColor = UIColor.white
                self.registerBtn.borderColor = AppColor.orange
                self.registerBtn.borderWidth = 2
            } else {
                
                self.registerBtn.setTitleColor(UIColor.white, for: .normal)
                self.registerBtn.backgroundColor = AppColor.orange
                self.registerBtn.cornerRadius = self.registerBtn.bounds.height / 2
                self.registerBtn.setTitle(NSLocalizedString("Done_title", comment: ""), for: .normal)
                self.registerBtn.borderWidth = 0
                
            }
        } ).drive(),output.jobError.do(onNext: {
            [weak self] (error) in
            if error != "" && !error.isEmpty {
                if self?.jobTextView.text != ""{
                    self?.jobTextView.rightViewMode = .always
                    let imageViewError = UIImageView(image: UIImage(named:"red-error"))
                    imageViewError.contentMode = .scaleToFill
                    imageViewError.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    imageViewError.sizeToFit()
                    NSLayoutConstraint.activate([
                        
                        imageViewError.widthAnchor.constraint(equalToConstant: 20),
                        imageViewError.heightAnchor.constraint(equalToConstant: 20)
                        
                    ])
                    self?.jobTextView.rightView = imageViewError
                    self?.jobTextView.errorText = error
                    self?.jobTextView.errorColor = AppColor.red
                }
                
            } else {
                if self?.jobTextView.text != ""{
                    self?.jobTextView.rightViewMode = .always
                    let imageView = UIImageView(image: UIImage(named:"green-ticke"))
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    imageView.sizeToFit()
                    NSLayoutConstraint.activate([
                        
                        imageView.widthAnchor.constraint(equalToConstant: 20),
                        imageView.heightAnchor.constraint(equalToConstant: 20)
                        
                    ])
                    self?.jobTextView.activeColor = AppColor.Green
                    self?.jobTextView.normalColor = AppColor.Green
                    self?.jobTextView.rightView = imageView
                    self?.jobTextView.errorText = nil
                    
                } else {
                    self?.jobTextView.normalColor = AppColor.black
                    self?.jobTextView.activeColor = AppColor.black
                    self?.jobTextView.rightView = nil
                    self?.jobTextView.errorText = nil
                }
            }
        }).drive(),output.personAvatar.drive(avatarBinding),output.personName.drive(personNamelabel.rx.text),output.error.drive(errorBinding),output.isFetching.drive(fetchingBinding)].forEach { (item) in
            item.disposed(by: disposeBag)
        }
    }
    
    var avatarBinding: Binder<String> {
        return Binder(self, binding: { (vc, url) in
            self.personImageView.image = UIImage(named: "person")
            if let url = URL(string: url ) {
                self.personImageView.kf.setImage(with: url)
            }
            
        })
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
                vc.startAnimation()
            } else {
                vc.stopAnimation()
            }
        })
    }
    
}
