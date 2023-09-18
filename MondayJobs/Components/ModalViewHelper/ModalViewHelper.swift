
import Foundation
import UIKit

@IBDesignable
class ModalViewHelper: UIView,Modal{
    
    //MARK: - Protocol Properties
    
    var timeInterval    : Double?
    var backgroundShadow: UIColor = UIColor.clear
    var backgroundView  : UIView = UIView()
    var dialogView      : UIView = UIView()
    
    
    @IBInspectable
    open var background: UIColor = .black {
        didSet {
            backgroundColor = background
        }
    }
    
    //MARK: - Initializer
    
    convenience init(view:UIView) {
        self.init(frame: UIScreen.main.bounds)
    }
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
    }
    
    init(view: UIView,timeInterval: Double?){
        super.init(frame: UIScreen.main.bounds)
        let screenSize = UIScreen.main.bounds

        dialogView.clipsToBounds = true
        self.timeInterval = timeInterval
        backgroundView.frame = frame
        backgroundView.backgroundColor = self.backgroundShadow
        backgroundView.alpha = 0.0
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        let dialogViewWidth = view.frame.width
        let dialogViewHeight = view.frame.height
        dialogView.frame.origin = CGPoint(x: 16, y: screenSize.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 4
        addSubview(dialogView)
        dialogView.addSubview(view)
        constSetter(view)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    

    
    
    // MARK: - Custom Methods
    
    func constSetter(_ view: UIView, const: CGFloat = 0){
        dialogView.topAnchor.constraint(equalTo: view.topAnchor , constant: const).isActive = true
        dialogView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: const).isActive = true
        dialogView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: const).isActive = true
        dialogView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: const).isActive = true
    }
    
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
  
}


