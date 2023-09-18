//
//  SnackBarView.swift
//  TestSnackBar
//
//  Created by Amir on 4/17/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import Foundation
import UIKit

typealias SnackBarAction = (()->Void)

struct SnackBarWithTimer {
    
    private var customView             : ModalViewHelper
    private var snackBarViewWithTimer  : SnackBarViewWithTimer!
    
    init(title:String ,
         userActionTitle:String? = nil,
         userAction: SnackBarAction? = nil,
         finished: SnackBarAction? = nil,
         duration: Double = 5.0) {
        snackBarViewWithTimer = SnackBarViewWithTimer(title: title,
                                                      userActionTitle: userActionTitle,
                                                      duration: duration,
                                                      userAction: userAction,
                                                      finished: finished)
        
        
        customView =  ModalViewHelper(view: snackBarViewWithTimer, timeInterval:duration)
    }
    
    func show(){
        customView.show(animated: true, place: CGPoint(x: customView.center.x, y: customView.center.y * 1.75))
    }
}

final class SnackBarViewWithTimer: UIView {
    
    @IBOutlet weak var progressRing: UICircularProgressRing! {
        didSet {
            progressRing.delegate = self
            progressRing.font = UIFont(name: "IRANYekan-Light", size: 14)!
            progressRing.backgroundColor = .clear
            progressRing.fontColor = .white
            progressRing.innerRingColor = .white
            progressRing.innerRingWidth = 2
            progressRing.outerRingWidth = 0
            progressRing.style = .inside
            progressRing.value = 100
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel?.text = title
            self.titleLabel?.font = UIFont(name: "IRANYekan-Light", size: 14)!
            titleLabel.textColor = .white
            titleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var userActionButton: UIButton! {
        didSet {
            userActionButton.titleLabel?.font =  UIFont(name: "IRANYekan(FaNum)", size: 14)!
            userActionButton.setTitleColor(AppColor.thirdLight, for: .normal)
            userActionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    private var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    private var timer: Timer!
    private var userAction: SnackBarAction?
    private var finished: SnackBarAction?
    private var duration: TimeInterval!
    fileprivate var beginDate: Date!
    fileprivate lazy var step: CGFloat = {
        let st = 100 / duration
        return CGFloat(st)
    }()
    
    convenience init(title: String, userActionTitle:String?, duration: Double, userAction: SnackBarAction?, finished: SnackBarAction?) {
        self.init(frame: UIScreen.main.bounds)
        let temp = fromNib() as! SnackBarViewWithTimer
        temp.initialize(title: title, userActionTitle: userActionTitle, duration: duration, userAction: userAction, finished: finished)
    }
    
    func initialize(title:String, userActionTitle:String?, duration: Double, userAction: SnackBarAction?, finished: SnackBarAction?){
        self.title = title
        self.userAction = userAction
        if let temp = userActionTitle {
            self.userActionButton?.setTitle(temp, for: .normal)
        }else{
            self.userActionButton?.removeFromSuperview()
        }
        self.finished = finished
        backgroundColor = .black
        self.duration = duration
        initializeTimer()
    }
    
    private func initializeTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration , execute: {
            self.timeFinished()
        })
        beginDate = Date()
        timer = Timer(timeInterval: 0.2, target: self, selector: #selector(timeInTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    @objc func timeInTimer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let newValue = self.progressRing.value - self.step

            self.progressRing.startProgress(to: newValue, duration: self.duration)
            if newValue <= 0 {
                self.timer?.invalidate()
            }
        }
    }
    
    
    @IBAction func pressedUserActionButton(_ sender: Any) {
        userAction?()
        userAction = nil
        finished = nil
        dismiss()
    }
    private func timeFinished() {
        finished?()
        userAction = nil
        finished = nil
        dismiss()
    }
    
    func dismiss() {
        guard let superView = self.superview?.superview?.superview as? ModalViewHelper else { return }
        UIView.animate(withDuration: 0.33, animations: {
            superView.backgroundView.alpha = 0
        }, completion: { (completed) in
            
        })
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
            superView.dialogView.center = CGPoint(x: superView.center.x, y: superView.frame.height + superView.dialogView.frame.height/2)
        }, completion: { (completed) in
            superView.removeFromSuperview()
        })
        
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension SnackBarViewWithTimer: UICircularProgressRingDelegate
{
    func didFinishProgress(for ring: UICircularProgressRing) {
        if ring.value <= 0 {
            timeFinished()
        }
    }
    
    func didPauseProgress(for ring: UICircularProgressRing) {
        
    }
    
    func didContinueProgress(for ring: UICircularProgressRing) {
        
    }
    
    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: CGFloat) {
        
    }
    
    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {
        let diff = Date().timeIntervalSince1970 - beginDate.timeIntervalSince1970
        var reverseDiff: Double = 0
        if diff >= 0 {
            reverseDiff = abs(duration - diff)
        }
        label.text = "\(Int(reverseDiff + 1))"
    }
}
