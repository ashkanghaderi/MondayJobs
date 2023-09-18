//
//  LandingViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 10/21/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import GoogleSignIn
import WebKit
import Domain
import NetworkPlatform
import RxSwift
import RxCocoa

class LandingViewController: BaseViewController{
    
    @IBOutlet weak var logoContainerView: UIView!
    @IBOutlet weak var googleImageView: UIView!
    @IBOutlet weak var linkedinImageView: UIView!
    @IBOutlet weak var headerView: BorderedView!
    @IBOutlet weak var headerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var linkdinBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    var viewModel: LandingViewModel!
    var webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "856675446880-4bvlousj9mnhh52df97r0do6hjbm2tne.apps.googleusercontent.com"
        
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
        
        headerHeightCons.constant = self.view.bounds.height / 3 + 30
        
        googleBtn.setTitleColor(AppColor.black, for: .normal)
        googleBtn.titleLabel?.font = Fonts.Bold.Bold16()
        googleBtn.setTitle(NSLocalizedString("by_google", comment: ""), for: .normal)
        
        linkdinBtn.setTitleColor(AppColor.linkdin, for: .normal)
        linkdinBtn.titleLabel?.font = Fonts.Bold.Bold16()
        linkdinBtn.setTitle(NSLocalizedString("by_linkdin", comment: ""), for: .normal)
        
        orLabel.text = NSLocalizedString("or", comment: "")
        orLabel.textColor = AppColor.black
        orLabel.font = Fonts.Regular.Regular15()
        
        registerLabel.text = NSLocalizedString("register_with", comment: "")
        registerLabel.textColor = AppColor.black
        registerLabel.font = Fonts.Regular.Regular17()
        
        registerBtn.setTitleColor(AppColor.orange, for: .normal)
        registerBtn.titleLabel?.font = Fonts.Regular.Regular17()
        registerBtn.setTitle(NSLocalizedString("another_account", comment: ""), for: .normal)
        
        loginLabel.text = NSLocalizedString("have_account", comment: "")
        loginLabel.textColor = AppColor.black
        loginLabel.font = Fonts.Regular.Regular13()
        
        loginBtn.setTitleColor(AppColor.orange, for: .normal)
        loginBtn.titleLabel?.font = Fonts.Regular.Regular13()
        loginBtn.setTitle(NSLocalizedString("log_in", comment: ""), for: .normal)
        
        let linked = UIView(SVGNamed: "linkedinSVG")
        linkedinImageView.addSubview(linked)
        
        let google = UIView(SVGNamed: "googleSVG")
        googleImageView.addSubview(google)
        
        let logo = UIView(SVGNamed: "logo-whiteSVG")
        
        logoContainerView.addSubview(logo)
        
    }
    func bindData() {
        let input = LandingViewModel.Input(registerTrigger: registerBtn.rx.tap.asDriver(), loginTrigger: loginBtn.rx.tap.asDriver(), googleTrigger: googleBtn.rx.tap.asDriver(), linkdinTrigger: linkdinBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.registerAction.drive(),output.loginAction.drive()
            ,output.googleAction.do(onNext: {
                (sender) in
                GIDSignIn.sharedInstance()?.signIn()
            }).drive(),output.linkdinAction.do(onNext: {
                (sender) in
                self.linkedInAuthVC()
            }).drive( ),output.error.drive(errorBinding),output.isFetching.drive()].forEach { (item) in
                item.disposed(by: disposeBag)
        }
    }
    
    
    
    func linkedInAuthVC() {
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
        ])
        
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI
        
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor(hexStr: "#0072B1")
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
}

extension LandingViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    self.startAnimation()
                    let request = AttendeeRegisterModel.Request( token: String(linkedinCode), provider: ProviderTypes.linkedin.rawValue)
                    _ = self.viewModel.useCase.RegisterUser(request: request).subscribe(onNext: { [unowned self](result) in
                        self.stopAnimation()
                        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                        
                        AuthorizationInfo.saveData(data: result)
                        
                        self.viewModel.navigator.toHome()
                       
                        
                        },onError: {(error) in
                            if let eError = error as? EliniumError{
                                self.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
                            }
                    })
                }
            }
        }
    }
    
}

extension LandingViewController : GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            //let fullName = user.profile.name
            //let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            //let email = user.profile.email
            guard let accessToken = user.authentication.idToken else { return }
            
            
            // let url = user.profile.hasImage ? user.profile.imageURL(withDimension: 100)?.absoluteString : ""
             
            self.startAnimation()
            let request = AttendeeRegisterModel.Request( token: accessToken, provider: ProviderTypes.google.rawValue)
            _ = self.viewModel.useCase.RegisterUser(request: request).subscribe(onNext: { [unowned self](result) in
                self.stopAnimation()
                UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
                AuthorizationInfo.saveData(data: result)
               
                self.viewModel.navigator.toHome()
                
                },onError: {(error) in
                    if let eError = error as? EliniumError{
                        self.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
                    }
            })

        } else {
            
            self.ShowSnackBar(snackModel: SnackModel(title: error.localizedDescription, duration: 5))
            print("\(error.localizedDescription)")
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    var errorBinding: Binder<Error> {
           return Binder(self, binding: { (vc, error) in
               if let eError = error as? EliniumError{
                   vc.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
               }
           })
       }
}





