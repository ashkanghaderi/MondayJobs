//
//  RegisterViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/21/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import MaterialComponents
import Material
import RxSwift
import RxCocoa
import Domain

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var passwordStatusImageView: UIView!
    @IBOutlet weak var passwordShowBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextView: MaterialTextField!
    @IBOutlet weak var jobTextView: MaterialTextField!
    @IBOutlet weak var emailTextView: MaterialTextField!
    @IBOutlet weak var passwordTextView: MaterialTextField!
    @IBOutlet weak var passwordErrorList: UILabel!
    @IBOutlet weak var workPermitBtn: CheckBox!
    @IBOutlet weak var workPermitLabel: UILabel!
    @IBOutlet weak var tasBtn: CheckBox!
    @IBOutlet weak var tasLabel: UILabel!
    @IBOutlet weak var tasSegueBtn: UIButton!
    @IBOutlet weak var registerBtn: BorderedButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var passError1Icon: UIImageView!
    @IBOutlet weak var passError1Label: UILabel!
    
    @IBOutlet weak var passError2Icon: UIImageView!
    @IBOutlet weak var passError2Label: UILabel!
    
    @IBOutlet weak var passError3Icon: UIImageView!
    @IBOutlet weak var passError3Label: UILabel!
    
    @IBOutlet weak var passError4Icon: UIImageView!
    @IBOutlet weak var passError4Label: UILabel!
    
    @IBOutlet weak var registerWidthCons: NSLayoutConstraint!
    
    var viewModel: RegisterViewModel!
    var  passHied : Bool = true
    var passErrors: [Bool] = []
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
        return .default
    }
    
    func setupUI(){
        
        
        titleLabel.text =  NSLocalizedString("register_title", comment: "")
        titleLabel.font = Fonts.Bold.Bold18()
        
        
        nameTextView.sizeToFit()
        nameTextView.borderColor = AppColor.Steel
        nameTextView.font = Fonts.Regular.Regular16()
        nameTextView.textContentType = .name
        nameTextView.activeColor = AppColor.black
        nameTextView.normalColor = AppColor.black
        (nameTextView.controller as? MaterialTextInputControllerOutlined)?.cornerRadius = 12
        nameTextView.placeholder = NSLocalizedString("register_name", comment: "")
        nameTextView.autocorrectionType = .no
        
        
        jobTextView.sizeToFit()
        jobTextView.borderColor = AppColor.Steel
        jobTextView.font = Fonts.Regular.Regular16()
        jobTextView.textContentType = .jobTitle
        jobTextView.activeColor = AppColor.black
        jobTextView.normalColor = AppColor.black
        (jobTextView.controller as? MaterialTextInputControllerOutlined)?.cornerRadius = 12
        jobTextView.placeholder = NSLocalizedString("register_job", comment: "")
        jobTextView.autocorrectionType = .no
        
        
        
        
        emailTextView.sizeToFit()
        emailTextView.borderColor = AppColor.Steel
        emailTextView.font = Fonts.Regular.Regular16()
        emailTextView.textContentType = .emailAddress
        emailTextView.activeColor = AppColor.black
        emailTextView.normalColor = AppColor.black
        (emailTextView.controller as? MaterialTextInputControllerOutlined)?.cornerRadius = 12
        emailTextView.placeholder = NSLocalizedString("register_email", comment: "")
        
        passwordTextView.sizeToFit()
        passwordTextView.borderColor = AppColor.Steel
        passwordTextView.font = Fonts.Regular.Regular16()
        passwordTextView.textContentType = .password
        passwordTextView.rightViewMode = .never
        passwordTextView.activeColor = AppColor.black
        passwordTextView.normalColor = AppColor.black
        (passwordTextView.controller as? MaterialTextInputControllerOutlined)?.cornerRadius = 12
        passwordTextView.placeholder = NSLocalizedString("register_pass", comment: "")
        passwordTextView.isSecureTextEntry = true
        passwordTextView.clearButton.isHidden = true
        passwordErrorList.isHidden = true
        passwordErrorList.font = Fonts.Regular.Regular12()
        passError1Label.font = Fonts.Regular.Regular12()
        passError2Label.font = Fonts.Regular.Regular12()
        passError3Label.font = Fonts.Regular.Regular12()
        passError4Label.font = Fonts.Regular.Regular12()
        passwordErrorList.isHidden = true
        passError4Icon.isHidden = true
        passError4Label.isHidden = true
        passError3Icon.isHidden = true
        passError3Label.isHidden = true
        passError2Icon.isHidden = true
        passError2Label.isHidden = true
        passError1Icon.isHidden = true
        passError1Label.isHidden = true
        
        let passwordShow = UIView(SVGNamed: "password-showSVG")
        passwordStatusImageView.addSubview(passwordShow)
        
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
        
        loginLabel.font = Fonts.Regular.Regular13()
        loginLabel.textColor = AppColor.black
        loginLabel.text = NSLocalizedString("login_label", comment: "")
        
        loginBtn.titleLabel?.font = Fonts.Regular.Regular13()
        loginBtn.setTitleColor(AppColor.orange, for: .normal)
        loginBtn.setTitle(NSLocalizedString("login_title", comment: ""), for: .normal)
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        if passwordTextView.text != "" {
        if passHied == true {
            passwordTextView.isSecureTextEntry = true
            let passwordShow = UIView(SVGNamed: "password-showSVG")
            passwordStatusImageView.removeSubviews()
            passwordStatusImageView.addSubview(passwordShow)
            //passwordShowBtn.setImage(UIImage(named: "password-show"), for: .normal)
            passwordTextView.setNeedsLayout()
            
        } else {
            passwordTextView.isSecureTextEntry = false
            let passwordHide = UIView(SVGNamed: "password-hideSVG")
            passwordStatusImageView.removeSubviews()
            passwordStatusImageView.addSubview(passwordHide)
            //passwordShowBtn.setImage(UIImage(named: "password-hide"), for: .normal)
            passwordTextView.setNeedsLayout()
        }
        
        passHied = !passHied
        }
    }
    
    func bindData() {
        let input = RegisterViewModel.Input(registerTrigger: registerBtn.rx.tap.asDriver(), loginTrigger: loginBtn.rx.tap.asDriver(),  workPermitTrigger: workPermitBtn.rx.tap.asDriver(), TASTrigger: tasBtn.rx.tap.asDriver(),TASSegueTrigger: tasSegueBtn.rx.tap.asDriver(), name: nameTextView.rx.text.orEmpty.debounce(.milliseconds(1000), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete().asDriver(), job: jobTextView.rx.text.orEmpty.debounce(.milliseconds(1000), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete().asDriver(), email: emailTextView.rx.text.orEmpty.debounce(.milliseconds(1000), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete().asDriver(), password: passwordTextView.rx.text.orEmpty.asDriver(),backTrigger: backBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.registerAction.drive(),output.loginAction.drive(),output.workPermitAction.drive(),output.TASAction.drive(),output.TASSegueAction.drive(),output.backAction.drive(),output.canRegister.do(onNext:{(status) in
            self.registerBtn.isEnabled = status
            if status == false {
                
                self.registerBtn.setTitleColor(AppColor.orange, for: .disabled)
                self.registerBtn.backgroundColor = UIColor.white
                self.registerBtn.borderColor = AppColor.orange
                self.registerBtn.borderWidth = 2
            } else {
                if self.passErrors.filter({$0 == false}).first == nil{
                    self.registerBtn.setTitleColor(UIColor.white, for: .normal)
                    self.registerBtn.backgroundColor = AppColor.orange
                    self.registerBtn.cornerRadius = self.registerBtn.bounds.height / 2
                    self.registerBtn.setTitle(NSLocalizedString("register_title", comment: ""), for: .normal)
                    self.registerBtn.borderWidth = 0
                } else {
                     self.registerBtn.isEnabled = false
                     self.registerBtn.setTitleColor(AppColor.orange, for: .disabled)
                     self.registerBtn.backgroundColor = UIColor.white
                     self.registerBtn.borderColor = AppColor.orange
                     self.registerBtn.borderWidth = 2
                }
            }
        } ).drive(),output.nameError.do(onNext: {
            [weak self] (error) in
            if error != "" && !error.isEmpty {
                if self?.nameTextView.text != ""{
                    self?.nameTextView.rightViewMode = .always
                    let imageViewError = UIImageView(image: UIImage(named:"red-error"))
                    imageViewError.contentMode = .scaleAspectFit
                    imageViewError.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    imageViewError.sizeToFit()
                    NSLayoutConstraint.activate([
                        
                        imageViewError.widthAnchor.constraint(equalToConstant: 20),
                        imageViewError.heightAnchor.constraint(equalToConstant: 20)
                        
                    ])
                    self?.nameTextView.rightView = imageViewError
                    self?.nameTextView.errorText = error
                    self?.nameTextView.errorColor = AppColor.red
                }
                
            } else {
                if self?.nameTextView.text != ""{
                    self?.nameTextView.rightViewMode = .always
                    let imageView = UIImageView(image: UIImage(named:"green-ticke"))
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    imageView.sizeToFit()
                    NSLayoutConstraint.activate([
                        
                        imageView.widthAnchor.constraint(equalToConstant: 20),
                        imageView.heightAnchor.constraint(equalToConstant: 20)
                        
                    ])
                    self?.nameTextView.normalColor = AppColor.Green
                    self?.nameTextView.activeColor = AppColor.Green
                    self?.nameTextView.rightView = imageView
                    self?.nameTextView.errorText = nil
                    
                } else {
                    self?.nameTextView.normalColor = AppColor.black
                    self?.nameTextView.activeColor = AppColor.black
                    self?.nameTextView.rightView = nil
                    self?.nameTextView.errorText = nil
                }
                
            }
            
            self?.nameTextView.setNeedsLayout()
            }).drive(),output.jobError.do(onNext: {
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
        }).drive(),output.emailError.do(onNext: {
            [weak self] (error) in
            if error != "" && !error.isEmpty {
                if self?.emailTextView.text != ""{
                    self?.emailTextView.rightViewMode = .always
                    let imageViewError = UIImageView(image: UIImage(named:"red-error"))
                    imageViewError.contentMode = .scaleAspectFit
                    imageViewError.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    imageViewError.sizeToFit()
                    NSLayoutConstraint.activate([
                        
                        imageViewError.widthAnchor.constraint(equalToConstant: 20),
                        imageViewError.heightAnchor.constraint(equalToConstant: 20)
                        
                    ])
                    self?.emailTextView.rightView = imageViewError
                    self?.emailTextView.errorText = error
                    self?.emailTextView.errorColor = AppColor.red
                }
            } else {
                if self?.emailTextView.text != ""{
                    self?.emailTextView.rightViewMode = .always
                    let imageView = UIImageView(image: UIImage(named:"green-ticke"))
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    imageView.sizeToFit()
                    NSLayoutConstraint.activate([
                        
                        imageView.widthAnchor.constraint(equalToConstant: 20),
                        imageView.heightAnchor.constraint(equalToConstant: 20)
                        
                    ])
                    self?.emailTextView.activeColor = AppColor.Green
                    self?.emailTextView.normalColor = AppColor.Green
                    self?.emailTextView.rightView = imageView
                    self?.emailTextView.errorText = nil
                    
                } else {
                    self?.emailTextView.normalColor = AppColor.black
                    self?.emailTextView.activeColor = AppColor.black
                    self?.emailTextView.rightView = nil
                    self?.emailTextView.errorText = nil
                }
            }
        }).drive(),output.passwordError.do(onNext: {
            [weak self] (error) in
            if error[0].count > 0 {
                self?.passErrors = []
                self?.passError1Icon.isHidden = false
                self?.passError1Label.isHidden = false
                self?.passError2Icon.isHidden = false
                self?.passError2Label.isHidden = false
                self?.passError3Icon.isHidden = false
                self?.passError3Label.isHidden = false
                self?.passError4Icon.isHidden = false
                self?.passError4Label.isHidden = false
                
                self?.passwordTextView.borderColor = AppColor.red
                self?.passwordErrorList.isHidden = false
                self?.passwordErrorList.text = NSLocalizedString("password_should", comment: "")
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
                
                self?.passwordErrorList.isHidden = true
                self?.passError4Icon.isHidden = true
                self?.passError4Label.isHidden = true
                self?.passError3Icon.isHidden = true
                self?.passError3Label.isHidden = true
                self?.passError2Icon.isHidden = true
                self?.passError2Label.isHidden = true
                self?.passError1Icon.isHidden = true
                self?.passError1Label.isHidden = true
            }
        }).drive(),output.error.drive(errorBinding),output.isFetching.drive(fetchingBinding)].forEach { (item) in
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
