
import UIKit
import RxSwift
import MaterialComponents.MaterialSnackbar


class BaseViewController: UIViewController,IndicatorProtocol {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupToHideKeyboardOnTapOnView()
    }
    
    func ShowSnackBar(snackModel:SnackModel){
        // should develop and decide
        self.stopAnimation()
        let msg = MDCSnackbarMessage(text: snackModel.title)
        msg.duration = snackModel.duration
        MDCSnackbarManager.default.snackbarMessageViewBackgroundColor = AppColor.orange
        MDCSnackbarManager.default.messageFont = Fonts.Regular.Regular14()
        MDCSnackbarManager.default.show(msg)
    }

}

extension BaseViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(BaseViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
