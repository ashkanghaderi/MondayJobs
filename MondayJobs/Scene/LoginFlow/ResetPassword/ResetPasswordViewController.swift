//
//  ResetPasswordViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/1/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import MaterialComponents
import Material
import RxSwift
import RxCocoa
import Domain


class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var headerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var passwordShowBtn: UIButton!
    @IBOutlet weak var rePasswordShowBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextView: MaterialTextField!
    @IBOutlet weak var rePasswordTextView: MaterialTextField!
    @IBOutlet weak var resetBtn: BorderedButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var errorStackView: UIStackView!
    @IBOutlet weak var passErrorShouldLabel: UILabel!
    
    @IBOutlet weak var passError1Icon: UIImageView!
    @IBOutlet weak var passError1Label: UILabel!
    
    @IBOutlet weak var passError2Icon: UIImageView!
    @IBOutlet weak var passError2Label: UILabel!
    
    @IBOutlet weak var passError3Icon: UIImageView!
    @IBOutlet weak var passError3Label: UILabel!
    
    @IBOutlet weak var passError4Icon: UIImageView!
    @IBOutlet weak var passError4Label: UILabel!
    
    var viewModel: ResetPasswordViewModel!
    var  passHied : Bool = true
    var passErrors: [Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindData()
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
        
        titleLabel.text =  NSLocalizedString("reset_pass_title", comment: "")
        titleLabel.font = Fonts.Bold.Bold18()
        
        passwordTextView.sizeToFit()
        passwordTextView.borderColor = AppColor.Steel
        passwordTextView.font = Fonts.Regular.Regular16()
        passwordTextView.textContentType = .password
        passwordTextView.rightViewMode = .never
        passwordTextView.activeColor = AppColor.black
        passwordTextView.normalColor = AppColor.black
        (passwordTextView.controller as? MaterialTextInputControllerOutlined)?.cornerRadius = 12
        passwordTextView.placeholder = NSLocalizedString("new_pass", comment: "")
        passwordTextView.isSecureTextEntry = true
        passwordTextView.clearButton.isHidden = true
        
        errorStackView.isHidden = true
        
        rePasswordTextView.sizeToFit()
        rePasswordTextView.borderColor = AppColor.Steel
        rePasswordTextView.font = Fonts.Regular.Regular16()
        rePasswordTextView.textContentType = .password
        rePasswordTextView.rightViewMode = .never
        rePasswordTextView.activeColor = AppColor.black
        rePasswordTextView.normalColor = AppColor.black
        (rePasswordTextView.controller as? MaterialTextInputControllerOutlined)?.cornerRadius = 12
        rePasswordTextView.placeholder = NSLocalizedString("confirm_pass", comment: "")
        rePasswordTextView.isSecureTextEntry = true
        rePasswordTextView.clearButton.isHidden = true
        
        passErrorShouldLabel.font = Fonts.Regular.Regular12()
        passError1Label.font = Fonts.Regular.Regular12()
        passError2Label.font = Fonts.Regular.Regular12()
        passError3Label.font = Fonts.Regular.Regular12()
        passError4Label.font = Fonts.Regular.Regular12()
        errorStackView.isHidden = true
        
        resetBtn.setTitleColor(UIColor.white, for: .normal)
        resetBtn.titleLabel?.font = Fonts.Regular.Regular15()
        resetBtn.backgroundColor = UIColor.white
        resetBtn.cornerRadius = resetBtn.bounds.height / 2
        resetBtn.setTitle(NSLocalizedString("reset_title", comment: ""), for: .normal)
        
        cancelBtn.titleLabel?.font = Fonts.Regular.Regular13()
        cancelBtn.setTitleColor(AppColor.orange, for: .normal)
        cancelBtn.setTitle(NSLocalizedString("cancel_title", comment: ""), for: .normal)
        
    }
    
    @IBAction func refreshPass(_ sender: Any) {
        if passwordTextView.text != "" {
            if passHied == true {
                passwordTextView.isSecureTextEntry = true
                passwordShowBtn.setImage(UIImage(named: "password-show"), for: .normal)
                passwordTextView.setNeedsLayout()
                
            } else {
                passwordTextView.isSecureTextEntry = false
                passwordShowBtn.setImage(UIImage(named: "password-hide"), for: .normal)
                passwordTextView.setNeedsLayout()
            }
            
            passHied = !passHied
        }
    }
    
    @IBAction func refreshRePass(_ sender: Any) {
        if rePasswordTextView.text != "" {
            if passHied == true {
                rePasswordTextView.isSecureTextEntry = true
                rePasswordShowBtn.setImage(UIImage(named: "password-show"), for: .normal)
                rePasswordTextView.setNeedsLayout()
                
            } else {
                rePasswordTextView.isSecureTextEntry = false
                rePasswordShowBtn.setImage(UIImage(named: "password-hide"), for: .normal)
                rePasswordTextView.setNeedsLayout()
            }
            
            passHied = !passHied
        }
    }
    
    func bindData() {
        assert(viewModel != nil)
        let input = ResetPasswordViewModel.Input(resetTrigger: resetBtn.rx.tap.asDriver(), cancelTrigger: cancelBtn.rx.tap.asDriver(), password: passwordTextView.rx.text.orEmpty.asDriver(), rePassword: rePasswordTextView.rx.text.orEmpty.debounce(.milliseconds(1500), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete().asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.resetAction.drive(),output.cancelAction.drive(),
            output.canReset.do(onNext: {(status) in
                self.resetBtn.isEnabled = status
                if status == false {
                    
                    self.resetBtn.setTitleColor(AppColor.orange, for: .disabled)
                    self.resetBtn.backgroundColor = UIColor.white
                    self.resetBtn.borderColor = AppColor.orange
                    self.resetBtn.borderWidth = 2
                } else {
                    if self.passErrors.filter({$0 == false}).first == nil{
                        self.resetBtn.setTitleColor(UIColor.white, for: .normal)
                        self.resetBtn.backgroundColor = AppColor.orange
                        self.resetBtn.cornerRadius = self.resetBtn.bounds.height / 2
                        self.resetBtn.setTitle(NSLocalizedString("reset_title", comment: ""), for: .normal)
                        self.resetBtn.borderWidth = 0
                    } else {
                         self.resetBtn.isEnabled = false
                         self.resetBtn.setTitleColor(AppColor.orange, for: .disabled)
                         self.resetBtn.backgroundColor = UIColor.white
                         self.resetBtn.borderColor = AppColor.orange
                         self.resetBtn.borderWidth = 2
                    }
                }
            }).drive(),output.rePasswordError.do(onNext: {
            [weak self] (error) in
            if error != "" && !error.isEmpty {
                if self?.rePasswordTextView.text != ""{
                    
                    self?.rePasswordTextView.errorText = error
                    self?.rePasswordTextView.errorColor = AppColor.red
                }
                
            } else {
                if self?.rePasswordTextView.text != ""{
                    
                    self?.rePasswordTextView.normalColor = AppColor.Green
                    self?.rePasswordTextView.activeColor = AppColor.Green
                    self?.rePasswordTextView.errorText = nil
                    
                } else {
                    self?.rePasswordTextView.normalColor = AppColor.black
                    self?.rePasswordTextView.activeColor = AppColor.black
                    self?.rePasswordTextView.errorText = nil
                }
                
            }
            
            self?.rePasswordTextView.setNeedsLayout()
            }).drive(),output.passwordError.do(onNext: {
                [weak self] (error) in
                if error[0].count > 0 {
                    self?.passErrors = []
                    self?.errorStackView.isHidden = false
                    
                    self?.passwordTextView.borderColor = AppColor.red
                    self?.passErrorShouldLabel.text = NSLocalizedString("password_should", comment: "")
                    let text = Array(error[0].keys)[0]
                    let status = NSString(string: error[0][text]!).boolValue
                    self?.passErrors.append(status)

                    let greenTickImage = UIImage(named: "green-ticke")!
                    let redErrorImage = UIImage(named: "red-error")!

                    self?.passError1Icon.image = status ? greenTickImage : redErrorImage
                    self?.passError1Label.text = text
                    self?.passError1Label.textColor = status ? AppColor.Green : AppColor.red
                    
                    let text1 = Array(error[1].keys)[0]
                    let status1 = NSString(string: error[1][text1]!).boolValue
                    self?.passErrors.append(status1)
                    
                    self?.passError2Icon.image = status1 ?  greenTickImage : redErrorImage
                    self?.passError2Label.text = text1
                    self?.passError2Label.textColor = status1 ? AppColor.Green : AppColor.red
                    
                    let text2 = Array(error[2].keys)[0]
                    let status2 = NSString(string: error[2][text2]!).boolValue
                    self?.passErrors.append(status2)
                    
                    self?.passError3Icon.image = status2 ?  greenTickImage : redErrorImage
                    self?.passError3Label.text = text2
                    self?.passError3Label.textColor = status2 ? AppColor.Green : AppColor.red
                    
                    let text3 = Array(error[3].keys)[0]
                    let status3 = NSString(string: error[3][text3]!).boolValue
                    self?.passErrors.append(status3)
                    
                    self?.passError4Icon.image = status3 ? greenTickImage : redErrorImage
                    self?.passError4Label.text = text3
                    self?.passError4Label.textColor = status3 ? AppColor.Green : AppColor.red
                    
                    if self?.passErrors.filter({$0 == false}).first != nil{
                        self?.passwordTextView.activeColor = AppColor.red
                        self?.passwordTextView.normalColor = AppColor.red
                    } else {
                        self?.passwordTextView.activeColor = AppColor.Green
                        self?.passwordTextView.normalColor = AppColor.Green
                    }
                    
                    
                } else {
                    
                    self?.passwordTextView.normalColor = AppColor.black
                    self?.passwordTextView.activeColor = AppColor.black
                    
                    self?.errorStackView.isHidden = true
                    
                }
            }).drive()
                   ,output.error.drive(errorBinding),output.isFetching.drive()].forEach { (item) in
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
    
    
}
