//
//  ProfileViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/13/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices
import UniformTypeIdentifiers
import Domain
import NetworkPlatform
import SafariServices


class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var skeletonView: UIView!{
        didSet{
            skeletonView.isHidden = true
        }
    }
    @IBOutlet weak var skeletonView1: UIView!{
        didSet{
            skeletonView1.isSkeletonable = true
            skeletonView1.skeletonCornerRadius = Float(skeletonView1.frame.size.width / 2)
        }
    }
    @IBOutlet weak var skeletonView2: UIView!{
        didSet{
            skeletonView2.isSkeletonable = true
            skeletonView2.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView3: UIView!{
        didSet{
            skeletonView3.isSkeletonable = true
            skeletonView3.skeletonCornerRadius = 8
        }
    }
    @IBOutlet weak var skeletonView4: UIView!{
        didSet{
            skeletonView4.isSkeletonable = true
            skeletonView4.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView5: UIView!{
        didSet{
            skeletonView5.isSkeletonable = true
            skeletonView5.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView6: UIView!{
        didSet{
            skeletonView6.isSkeletonable = true
            skeletonView6.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView7: UIView!{
        didSet{
            skeletonView7.isSkeletonable = true
            skeletonView7.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView8: UIView!{
        didSet{
            skeletonView8.isSkeletonable = true
            skeletonView8.skeletonCornerRadius = 8
        }
    }
    @IBOutlet weak var skeletonView9: UIView!{
        didSet{
            skeletonView9.isSkeletonable = true
            skeletonView9.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView10: UIView!{
        didSet{
            skeletonView10.isSkeletonable = true
            skeletonView10.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView11: UIView!{
        didSet{
            skeletonView11.isSkeletonable = true
            skeletonView11.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView12: UIView!{
        didSet{
            skeletonView12.isSkeletonable = true
            skeletonView12.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView13: UIView!{
        didSet{
            skeletonView13.isSkeletonable = true
            skeletonView13.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView14: UIView!{
        didSet{
            skeletonView14.isSkeletonable = true
            skeletonView14.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView15: UIView!{
        didSet{
            skeletonView15.isSkeletonable = true
            skeletonView15.skeletonCornerRadius = 8
        }
    }
    @IBOutlet weak var skeletonView16: UIView!{
        didSet{
            skeletonView16.isSkeletonable = true
            skeletonView16.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView17: UIView!{
        didSet{
            skeletonView17.isSkeletonable = true
            skeletonView17.skeletonCornerRadius = 12
        }
    }
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var imageVIewContainer: UIView!
    @IBOutlet weak var doneBtn: UIButton!{
        didSet{
            doneBtn.isSkeletonable = true
            doneBtn.skeletonCornerRadius = Float(doneBtn.frame.size.height / 2)
        }
    }
    @IBOutlet weak var pageTitle: UILabel!
    {
        didSet{
            pageTitle.isSkeletonable = true
            pageTitle.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            backBtn.isSkeletonable = true
            backBtn.skeletonCornerRadius = Float(backBtn.frame.size.height / 2)
        }
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chnageImageBtn: UIButton!
    @IBOutlet weak var userImageTitleLabel: UILabel!
    
    @IBOutlet weak var preferencesTitle: UILabel!
    @IBOutlet weak var shareResumeTitle: UILabel!
    @IBOutlet weak var shareResumeSwitch: UISwitch!
    @IBOutlet weak var shareLinkedinTitle: UILabel!
    @IBOutlet weak var shareLinkedinSwitch: UISwitch!
    
    @IBOutlet weak var personaTitle: UILabel!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var bioTitle: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var jobTitleTitle: UILabel!
    @IBOutlet weak var jobTitleTextFiled: UITextField!
    @IBOutlet weak var onlineCVTitle: UILabel!
    @IBOutlet weak var onlineCVFileName: UIButton!
    @IBOutlet weak var uploadResumeBtn: UIButton!
    @IBOutlet weak var ClearImageView: UIView!
    @IBOutlet weak var clearResumeBtn: UIButton!
    
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailTextFiled: UITextField!
    
    @IBOutlet weak var linkedinTitle: UILabel!
    @IBOutlet weak var linkedinTextFiled: UITextField!
    
    @IBOutlet weak var logoutTitle: UILabel!
    @IBOutlet weak var logoutTitleLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    @IBOutlet weak var viewBottomCons: NSLayoutConstraint!
    var viewModel : ProfileViewModel!
    var imagePicker: ImagePicker!
    var currentResumeURL: URL?
    public var didSelectDocument = PublishSubject<Data>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        setupUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func startSkeletonAnimation(){
        
        self.formView.isHidden = true
        self.skeletonView.isHidden = false
        
        skeletonView.sizeToFit()
        skeletonView.layoutIfNeeded()
        
        [pageTitle,
         doneBtn,
         backBtn,
         skeletonView1,
         skeletonView2,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6,
         skeletonView7,
         skeletonView8,
         skeletonView9,
         skeletonView10,
         skeletonView11,
         skeletonView12,
         skeletonView13,
         skeletonView14,
         skeletonView15,
         skeletonView16,
         skeletonView17
        ].forEach({$0?.showAnimatedGradientSkeleton()})
    }
    
    private func stopSkeletonAnimation(){
        
        [pageTitle,
         doneBtn,
         backBtn,
         skeletonView1,
         skeletonView2,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6,
         skeletonView7,
         skeletonView8,
         skeletonView9,
         skeletonView10,
         skeletonView11,
         skeletonView12,
         skeletonView13,
         skeletonView14,
         skeletonView15,
         skeletonView16,
         skeletonView17
        ].forEach({$0?.hideSkeleton()})
        
        self.formView.isHidden = false
        self.skeletonView.isHidden = true
        
    }


    func setupUI(){
       
        imageVIewContainer.layer.cornerRadius = imageVIewContainer.frame.size.width / 2
        
        [personaTitle,nameTitle,bioTitle,
         jobTitleTitle,onlineCVTitle,
         emailTitle,
         linkedinTitle,logoutTitleLabel,
         shareLinkedinTitle,shareResumeTitle].forEach({
            $0?.font = Fonts.Regular.Regular15()
        })
        
        [nameTextFiled,
         jobTitleTextFiled,
         emailTextFiled,
         linkedinTextFiled].forEach({
            $0?.font = Fonts.Regular.Regular15()
        })
        
        userImageTitleLabel.font = Fonts.Bold.Bold24()
        userImageTitleLabel.textColor = UIColor.white

        personaTitle.textColor = UIColor.black.withAlphaComponent(0.6)
        personaTitle.font = Fonts.Regular.Regular15()
        preferencesTitle.textColor = UIColor.black.withAlphaComponent(0.6)
        preferencesTitle.font = Fonts.Regular.Regular15()
        logoutTitle.textColor = UIColor.black.withAlphaComponent(0.6)
        logoutTitle.font = Fonts.Regular.Regular15()
        
        
        
        doneBtn.setTitle(NSLocalizedString("done_title", comment: ""))
        doneBtn.titleLabel?.font = Fonts.Regular.Regular15()
        pageTitle.text = NSLocalizedString("profile_title", comment: "")
        chnageImageBtn.setTitle(NSLocalizedString("change_image_title", comment: ""))
        chnageImageBtn.titleLabel?.font = Fonts.Regular.Regular13()
        
        [doneBtn,uploadResumeBtn,onlineCVFileName,
         chnageImageBtn].forEach({
            $0?.setTitleColor(AppColor.blue, for: .normal)
        })
        
        let trash = UIView(SVGNamed: "trashSVG")
        
        ClearImageView.addSubview(trash)
        
        nameTitle.text = NSLocalizedString("name_title", comment: "")
        bioTitle.text = NSLocalizedString("pitch_title", comment: "")
        jobTitleTitle.text = NSLocalizedString("job_title", comment: "")
        emailTitle.text = NSLocalizedString("email_title", comment: "")
        linkedinTitle.text = NSLocalizedString("linkedin_title", comment: "")
        onlineCVTitle.text = NSLocalizedString("cv_title", comment: "")
        shareLinkedinTitle.text = NSLocalizedString("share_linkedin_title", comment: "")
        shareResumeTitle.text = NSLocalizedString("share_resume_title", comment: "")
        logoutTitle.text = NSLocalizedString("logout_title", comment: "")
        logoutTitleLabel.text = NSLocalizedString("logout_title", comment: "")
        logoutBtn.setTitle(NSLocalizedString("logout_title", comment: ""))
        uploadResumeBtn.setTitle(NSLocalizedString("upload_resume_title", comment: ""))
    }
    
    func bindData() {
        
        let logoutTrigger = logoutBtn.rx.tap.flatMap {
            return Observable<Void>.create { observer in

                let alert = UIAlertController(title: "Log out",
                    message: "Are you sure you want to log out?",
                    preferredStyle: .alert
                )
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ -> () in observer.onNext(()) })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)

                self.present(alert, animated: true, completion: nil)

                return Disposables.create()
            }
        }.asDriverOnErrorJustComplete()
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
       
        
        let input = ProfileViewModel.Input(jobTitle: jobTitleTextFiled.rx.text.orEmpty.asDriver(), pitchText: bioTextView.rx.text.orEmpty.asDriver(), linkedin: linkedinTextFiled.rx.text.orEmpty.asDriver(), resumeSharing: shareResumeSwitch.rx.value.asDriver(), linkedinSharing: shareLinkedinSwitch.rx.value.asDriver(), uploadResumeTrigger: self.rx.didSelectDoc.asDriver(), uploadImageTrigger: self.imagePicker.rx.didSelectImage.asDriver(), logoutTrigger: logoutTrigger, doneTrigger: doneBtn.rx.tap.asDriver(), loadTrigger: viewWillAppear, backTrigger: backBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.doneAction.drive(ProfileBinding),
         output.loadAction.drive(ProfileBinding),
         output.backAction.drive(),
         output.logoutAction.drive(),
         output.uploadImageAction.drive(avatarBinding),
         output.uploadResumeAction.drive(resumeBinding),
         output.error.drive(errorBinding),
         output.isFetching.drive(fetchingBinding)].forEach { (item) in
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

    var ProfileBinding: Binder<ProfileModel> {
        return Binder(self, binding: { (vc, profile) in
            //let urlStr = BaseURL.dev.rawValue + "/" + (profile.avatarUrl ?? "")
            if let avatarUrl = profile.avatarUrl, let url = URL(string: BaseURL.dev.rawValue + "/" + avatarUrl) {
                self.userImage.isHidden = false
                self.userImage.kf.setImage(with: url)
                //self.imageVIewContainer.backgroundColor = UIColor.clear
                self.userImageTitleLabel.isHidden = true
            } else {
                self.userImage.isHidden = true
                self.imageVIewContainer.backgroundColor = UIColor.random()
                self.userImageTitleLabel.isHidden = false
                self.userImageTitleLabel.text = profile.name?.prefix(1).uppercased()
            }
            //AuthorizationInfo.save(profile.avatarUrl, key: "avatarUrl")
            AuthorizationInfo.save(profile.jobTitle, key: "jobTitle")
            
            self.nameTextFiled.text = profile.name
            self.jobTitleTextFiled.text = profile.jobTitle
            self.bioTextView.text = profile.about
            self.emailTextFiled.text = profile.email
            self.linkedinTextFiled.text = profile.linkedInUrl
            self.shareResumeSwitch.isSelected = profile.autoShareResume ?? true
            self.shareLinkedinSwitch.isSelected = profile.autoShareLinkedIn ?? true
            if let fileName = profile.resumeFileName {
                self.onlineCVFileName.setTitle(fileName)
                self.ClearImageView.isHidden = false
                self.clearResumeBtn.isHidden = false
            } else {
                self.onlineCVFileName.setTitle("")
                self.ClearImageView.isHidden = true
                self.clearResumeBtn.isHidden = true
            }
            //self.onlineCVFileName.setTitle(AuthorizationInfo.get(by: "resumeFileName"))
            

        })
    }
    
    var avatarBinding: Binder<ProfileModel> {
        return Binder(self, binding: { (vc, profile) in
            AuthorizationInfo.save(profile.avatarUrl, key: "avatarUrl")
            let urlStr = BaseURL.dev.rawValue + "/" + (profile.avatarUrl ?? "")
            if let url = URL(string: urlStr ) {
                self.userImage.isHidden = false
                self.userImage.kf.setImage(with: url)
                //self.imageVIewContainer.backgroundColor = UIColor.clear
                self.userImageTitleLabel.isHidden = true
            } else {
                self.userImage.isHidden = true
                self.imageVIewContainer.backgroundColor = UIColor.random()
                self.userImageTitleLabel.isHidden = false
                self.userImageTitleLabel.text = profile.name?.prefix(1).uppercased()
            }

        })
    }
    
    var resumeBinding: Binder<ProfileModel> {
        return Binder(self, binding: { (vc, profile) in
            AuthorizationInfo.save(profile.resumeUrl, key: "resumeUrl")
            AuthorizationInfo.save(profile.resumeFileName, key: "resumeFileName")
            self.onlineCVFileName.setTitle(profile.resumeFileName)
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

    

    @IBAction func onSelectImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func onSelectDocument(_ sender: Any) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        //Call Delegate
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    @IBAction func onPreviewResume(_ sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if text.count > 0{
                do {
                    let urlStr = BaseURL.dev.rawValue + "/" + (AuthorizationInfo.get(by: "resumeUrl") ?? "")
                    guard let url = URL(string: urlStr) else {return}
                    let docData = try NSData(contentsOf: url, options: NSData.ReadingOptions())
                    //print(docData)
                    let activityItems = [docData]
                    let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

                    self.present(activityController, animated: true, completion: {  })
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async {
                
                self.viewBottomCons.constant = keyboardSize.height
                
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        DispatchQueue.main.async {
            
            self.viewBottomCons.constant = 0
            
        }
        
    }
}

extension ProfileViewController: ImagePickerDelegate {
    func didSelect(imageModel: UploadFileModel) {
        
    }
}

extension ProfileViewController : UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        
        do {
            self.currentResumeURL = myURL
            let docData = try Data(contentsOf: myURL, options: NSData.ReadingOptions())
            self.didSelectDocument.onNext(docData)
            
        } catch {
            print(error)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension Reactive where Base: ImagePicker {
    

    public var didSelectImage: ControlEvent<UploadFileModel> {
        
        return ControlEvent(events: self.base.didSelectSubject)
        
    }
}

extension Reactive where Base: ProfileViewController {
    

    internal var didSelectDoc: ControlEvent<Data> {
        
        return ControlEvent(events: self.base.didSelectDocument)
        
    }
}

