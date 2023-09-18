//
//  LoginViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/31/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Domain

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var headerView: BorderedView!
    @IBOutlet weak var contentTopCons: NSLayoutConstraint!
    @IBOutlet weak var emailTextView: MaterialTextField!
    @IBOutlet weak var passwordTextView: MaterialTextField!
    @IBOutlet weak var passwordShowBtn: UIButton!
    @IBOutlet weak var loginBtn: BorderedButton!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerHeightCons: NSLayoutConstraint!
    
    var viewModel: LoginViewModel!
    var  passHied : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setupUI()
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
        assert(viewModel != nil)
        
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
        
        loginBtn.setTitleColor(AppColor.orange, for: .disabled)
        loginBtn.backgroundColor = UIColor.white
        loginBtn.borderColor = AppColor.orange
        loginBtn.borderWidth = 2
        loginBtn.titleLabel?.font = Fonts.Regular.Regular16()
        loginBtn.cornerRadius = loginBtn.bounds.height / 2
        loginBtn.setTitle(NSLocalizedString("login_title", comment: ""), for: .normal)
        forgotPassBtn.titleLabel?.font = Fonts.Regular.Regular13()
        forgotPassBtn.setTitleColor(AppColor.orange, for: .normal)
        forgotPassBtn.setTitle(NSLocalizedString("forgot_password", comment: ""), for: .normal)
        headerView.backgroundColor = AppColor.orange
        headerHeightCons.constant = self.view.bounds.height / 3 + 45
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
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
    
    func bindData() {
        let input = LoginViewModel.Input(loginTrigger: loginBtn.rx.tap.asDriver(), forgotPassTrigger: forgotPassBtn.rx.tap.asDriver(), backTrigger: backBtn.rx.tap.asDriver(), email: emailTextView.rx.text.orEmpty.debounce(.milliseconds(1500), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete().asDriver(), password: passwordTextView.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.loginAction.drive(),output.forgotPassAction.drive(),
         output.canLogin.do(onNext: {(status) in
            self.loginBtn.isEnabled = status
            if status == false {
                
                self.loginBtn.setTitleColor(AppColor.orange, for: .disabled)
                self.loginBtn.backgroundColor = UIColor.white
                self.loginBtn.borderColor = AppColor.orange
                self.loginBtn.borderWidth = 2
                
            } else {
                
                self.loginBtn.setTitleColor(UIColor.white, for: .normal)
                self.loginBtn.backgroundColor = AppColor.orange
                self.loginBtn.cornerRadius = self.loginBtn.bounds.height / 2
                self.loginBtn.setTitle(NSLocalizedString("login_title", comment: ""), for: .normal)
                self.loginBtn.borderWidth = 0
                
            }
         }).drive(),output.canReset.do(onNext: {(status) in
            self.forgotPassBtn.isEnabled = status
            if status == false {
                
               self.forgotPassBtn.setTitleColor(AppColor.Steel, for: .disabled)
                
            } else {
                
                self.forgotPassBtn.setTitleColor(AppColor.orange, for: .normal)

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
         }).drive(),output.backAction.drive()
            ,output.error.drive(errorBinding),output.isFetching.drive(fetchingBinding)].forEach { (item) in
                item.disposed(by: disposeBag)
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async {
                self.contentTopCons.constant = 10
               
                self.headerHeightCons.constant = self.view.bounds.height / 3 - 45
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.contentTopCons.constant = 60
        self.headerHeightCons.constant = self.view.bounds.height / 3 + 45
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
