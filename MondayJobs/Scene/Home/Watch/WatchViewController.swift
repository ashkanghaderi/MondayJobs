//
//  WatchViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/18/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NetworkPlatform
import Domain
import RxGesture

class WatchViewController: BaseViewController {
    
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
            skeletonView3.skeletonCornerRadius = Float(skeletonView3.frame.size.width / 2)
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
            skeletonView5.skeletonCornerRadius = Float(skeletonView5.frame.size.width / 2)
        }
    }
    @IBOutlet weak var skeletonView6: UIView!{
        didSet{
            skeletonView6.isSkeletonable = true
            skeletonView6.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var noResultView: UIView!{
        didSet{
            noResultView.isHidden = true
        }
    }
    @IBOutlet weak var viewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 14
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{

            tableView.register(MenuViewCell.self)
            tableView.estimatedRowHeight = 64
            tableView.rowHeight = UITableView.automaticDimension
            tableView.customStyle()
            tableView.refreshControl = UIRefreshControl()
        }
    }
    
    var viewModel: WatchViewModel!
    public var didTapBlur = PublishSubject<Void>()
    var isLoading : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.sizeToFit()
        containerView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
        viewHeightCons.constant = self.view.frame.size.height / 3
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        blurView.addGestureRecognizer(tap)
        
        bindViewModel()
        
    }
    
    private func startSkeletonAnimation(){
        
        self.tableView.isHidden = true
        self.skeletonView.isHidden = false
        
        skeletonView.sizeToFit()
        skeletonView.layoutIfNeeded()
        
        [skeletonView1,
         skeletonView2,
         skeletonView1,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6
        ].forEach({$0?.showAnimatedGradientSkeleton()})
    }
    
    private func stopSkeletonAnimation(){
        
        [skeletonView1,
         skeletonView2,
         skeletonView1,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6
        ].forEach({$0?.hideSkeleton()})
        
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.isHidden = false
        self.skeletonView.isHidden = true
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        didTapBlur.onNext(())
    }


    private func bindViewModel() {
        assert(viewModel != nil)
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        
        let input = WatchViewModel.Input(selectMenuItemTrigger: tableView.rx.itemSelected.asDriver(), viewWillAppearTrigger: Driver.merge(viewWillAppear, pull), dismissTrigger: self.rx.didTap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.menuItems.do(onNext: { [weak self] items in
            guard let self = self else { return }
            
            if items.count == 0 {
                self.tableView.isHidden = true
                self.noResultView.isHidden = false
            }
        }).drive(tableView.rx.items(cellIdentifier: MenuViewCell.reuseID, cellType: MenuViewCell.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        output.dismissAction
            .drive()
            .disposed(by: disposeBag)
        output.isFetching
            .drive(fetchingBinding)
            .disposed(by: disposeBag)
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)
        output.selectedMenuItem
            .drive()
            .disposed(by: disposeBag)
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            if let eError = error as? EliniumError{
                vc.stopSkeletonAnimation()
                vc.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
            }
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

}

extension Reactive where Base: WatchViewController {
    

    internal var didTap: ControlEvent<Void> {
        
        return ControlEvent(events: self.base.didTapBlur)
        
    }
}

