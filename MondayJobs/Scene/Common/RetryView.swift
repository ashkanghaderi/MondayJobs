

import Foundation
import RxCocoa


class RetryView {
     let retryButton = UIButton()
     var vc:UIViewController?
    
    private func create() -> UIViewController{
        let mainView = UIViewController()
        let stack   = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        stack.spacing = 16.0
        
        let image   = UIImageView(image: #imageLiteral(resourceName: "internet_error"))
        image.contentMode = .scaleAspectFit
        
        let massegeLabel = UILabel()
        massegeLabel.text =  Localization.internetError.rawValue
        massegeLabel.font = AppFont.labels.description()
        massegeLabel.textColor = AppColor.color4C4C4C
        massegeLabel.sizeToFit()
        
       
        retryButton.setTitle( Localization.retryAction.rawValue, for: .normal)
        retryButton.titleLabel?.font = AppFont.buttons.regularCaption()
        retryButton.setTitleColor(AppColor.color4C4C4C, for: .normal)
        
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = AppColor.color4C4C4C.cgColor
        retryButton.sizeToFit()
        retryButton.layer.cornerRadius =  retryButton.frame.height/2
        retryButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        retryButton.clipsToBounds = true
        
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(massegeLabel)
        stack.addArrangedSubview(retryButton)
        
        mainView.view.addSubview(stack)
        stack.center.y =  mainView.view.center.y
        stack.center.x =  mainView.view.center.x
        stack.sizeToFit()
        mainView.view.backgroundColor = AppColor.colorFFFFFF
        
        let logoImage       = UIImageView(image: #imageLiteral(resourceName: "simple_farsi").withRenderingMode(.alwaysTemplate))
        logoImage.tintColor = AppColor.color4C4C4C
        
        mainView.view.addSubview(logoImage)
        logoImage.frame = CGRect(x:UIScreen.main.bounds.width/2 - 28, y: 35, width: 56, height: 24)
       
        return mainView
    }
    
    func didTap()  -> Driver<Void>{
        
        vc = create()
        return   retryButton
                      .rx
                      .tap
                      .asDriver()
    }
 
    
    func show(){
        if let vc = vc,
            UIApplication.topViewController() != vc{
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle   = .crossDissolve
        UIApplication.topViewController()?.present(vc, animated: true, completion:nil)
        }}
}
