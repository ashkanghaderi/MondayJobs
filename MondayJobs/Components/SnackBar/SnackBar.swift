
import Foundation
import UIKit

// MARK: - SnackBarView

fileprivate class SnackBarView: UIView {
    
    var titleLabel: UILabel     = UILabel()
    var actionButton: UIButton! = UIButton(type: .custom)
    var clousre: ()->() = {}
    
    
    //    MARK: - initilizer
    
    convenience init(model: SnackModel) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 45))
        
        backgroundColor = .black
        
        if let action = model.actionClousre {
            clousre = action
        }
        
        titleLabel.text = model.title
        titleLabel.sizeToFit()
        
        if let actionTitle = model.actionTitle {
            actionButton.setTitle(actionTitle, for: .normal)
            actionButton.sizeToFit()
        }else{
            actionButton.isHidden = true
        }
        setData()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(){
        let stackFrame =  CGRect(x: self.frame.minX + 8,
                                 y: self.frame.minY,
                                 width: self.frame.width - 16,
                                 height: self.frame.height)
        let stackView = UIStackView(frame:stackFrame )
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        titleLabel.font = Fonts.Light.Light14()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = AppColor.colorFFFFFF
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .left
        actionButton.titleLabel?.font = Fonts.Light.Light14()
        actionButton.setTitleColor(AppColor.colorFC2B2D, for: .normal)
        
        
        stackView.addArrangedSubview(actionButton)
        stackView.addArrangedSubview(titleLabel)
        self.addSubview(stackView)
        
    }
    
    
    // MARK: - custom Methods
    
    @IBAction func action(_ sender: Any) {
        clousre()
    }     
    
}

// MARK: - SnackModel

struct SnackModel {
    let title           : String
    let duration        : TimeInterval
    let description     : String?
    let icon            : UIImage? /// if not nil, icon will be replaced with retry icon
    let apiError        : String?
    var actionTitle     : String?
    var actionClousre   : (() -> Void)?
    
    init(title          : String = "",
         duration       : TimeInterval = 3.0,
         description    : String? = nil,
         icon           : UIImage? = nil,
         actionTitle    : String? = nil,
         actionclousre  : (() -> Void)? = nil,
         apiError       : String? = nil) {
        
        self.title          = title
        self.duration       = duration
        self.description    = description
        self.icon           = icon
        self.actionTitle    = actionTitle
        self.actionClousre  = actionclousre
        self.apiError       = apiError
    }
}

// MARK: - SnackBar

struct SnackBar {
    private let modalView : ModalViewHelper
    private var snackBarView: SnackBarView!
    
    init(model: SnackModel) {
        snackBarView = SnackBarView(model: model)
        modalView =  ModalViewHelper(view: snackBarView, timeInterval: model.duration)
    }
    
    // should be deleted
    init(message: Message,timeInterval:Double?) {
        let model = SnackModel(title: message.title, duration: timeInterval ?? 3.0)
        self.init(model: model)
        
    }
    
    // should be deleted
    init(title:String , actionTitle:String? = nil, action:(()->Void)? = nil,timeInterval:Double = 3.0){
        let model = SnackModel(title: title, duration: timeInterval, actionclousre: action)
        self.init(model: model)
    }
    
    func show(){
        modalView.show(animated: true, place: CGPoint(x: modalView.center.x, y: modalView.center.y * 1.75))
    }
    
}
