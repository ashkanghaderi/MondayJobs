//
//  CompanyViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/12/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Domain
import SkeletonView

protocol JobSelectDelegate {
    func didSelectJob(model: JobItemModel)
}
protocol AgentSelectDelegate {
    func didSelectAgent(model: AgentModel)
}
class CompanyViewController: BaseViewController {
    
    @IBOutlet weak var skeletonView:  UIView!
    @IBOutlet weak var skeletonView2  : UIView!{
        didSet{
            skeletonView2.isSkeletonable = true
            skeletonView2.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView1  : UIView!{
        didSet{
            skeletonView1.isSkeletonable = true
            skeletonView1.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView3  : UIView!{
        didSet{
            skeletonView3.isSkeletonable = true
            skeletonView3.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView4  : UIView!{
        didSet{
            skeletonView4.isSkeletonable = true
            skeletonView4.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView5  : UIView!{
        didSet{
            skeletonView5.isSkeletonable = true
            skeletonView5.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView6  : UIView!{
        didSet{
            skeletonView6.isSkeletonable = true
            skeletonView6.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView7  : UIView!{
        didSet{
            skeletonView7.isSkeletonable = true
            skeletonView7.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView9  : UIView!{
        didSet{
            skeletonView9.isSkeletonable = true
            skeletonView9.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView10 : UIView!{
        didSet{
            skeletonView10.isSkeletonable = true
            skeletonView10.skeletonCornerRadius = 8
        }
    }
    @IBOutlet weak var skeletonView11 : UIView!{
        didSet{
            skeletonView11.isSkeletonable = true
            skeletonView11.skeletonCornerRadius = 12
        }
    }
    
    @IBOutlet weak var skeletonView8  : UIView!{
        didSet{
            skeletonView8.isSkeletonable = true
            skeletonView8.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView12 : UIView!{
        didSet{
            skeletonView12.isSkeletonable = true
            skeletonView12.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView13 : UIView!{
        didSet{
            skeletonView13.isSkeletonable = true
            skeletonView13.skeletonCornerRadius = 8
        }
    }
    @IBOutlet weak var skeletonView14 : UIView!{
        didSet{
            skeletonView14.isSkeletonable = true
            skeletonView14.skeletonCornerRadius = 12
        }
    }
    
    @IBOutlet weak var skeletonView23 : UIView!{
        didSet{
            skeletonView23.isSkeletonable = true
            skeletonView23.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView24 : UIView!{
        didSet{
            skeletonView24.isSkeletonable = true
            skeletonView24.skeletonCornerRadius = 12
        }
    }
    @IBOutlet weak var skeletonView25 : UIView!{
        didSet{
            skeletonView25.isSkeletonable = true
            skeletonView25.skeletonCornerRadius = 8
        }
    }
    @IBOutlet weak var skeletonView26 : UIView!{
        didSet{
            skeletonView26.isSkeletonable = true
            skeletonView26.skeletonCornerRadius = 12
        }
    }
    
    @IBOutlet weak var imageContainerView: BorderedView!{
        didSet{
            imageContainerView.cornerRadius = imageContainerView.frame.size.width/2
        }
    }
    @IBOutlet weak var imageContainerViewTitle: UILabel!{
        didSet{
            imageContainerViewTitle.font = Fonts.Bold.Bold16()
            imageContainerViewTitle.textColor = UIColor.white
        }
    }
    @IBOutlet weak var pageTitle: UILabel!
    {
        didSet{
            pageTitle.isSkeletonable = true
            pageTitle.layer.cornerRadius = 8
            //pageTitle.skeletonCornerRadius = 8
            pageTitle.font = Fonts.Regular.Regular14()
            pageTitle.text = NSLocalizedString("company_profile", comment: "")
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(SpaceTableViewCell.self)
            tableView.register(AgentsTableViewCell.self)
            tableView.register(DescTableViewCell.self)
            tableView.register(JobsTableViewCell.self)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.customStyle()
            tableView.refreshControl = UIRefreshControl()
        }
    }
    @IBOutlet weak var companyMenuBtn: UIButton!{
        didSet{
            companyMenuBtn.isSkeletonable = true
            companyMenuBtn.skeletonCornerRadius = Float(companyMenuBtn.frame.size.width / 2)
        }
    }
    @IBOutlet weak var companyOptionBtn: UIButton!{
        didSet{
            companyOptionBtn.isSkeletonable = true
            companyOptionBtn.skeletonCornerRadius = 10
        }
    }
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            backBtn.isSkeletonable = true
            backBtn.skeletonCornerRadius = 10
        }
    }
    @IBOutlet weak var startInterviewBtn: BorderedButton!{
        didSet{
            startInterviewBtn.isSkeletonable = true
            startInterviewBtn.skeletonCornerRadius = 10
        }
    }
    @IBOutlet weak var companyName: UILabel!
    {
        didSet{
            companyName.isSkeletonable = true
            companyName.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var companyImage: UIImageView!{
        didSet{
            companyImage.isSkeletonable = true
            companyImage.skeletonCornerRadius = Float(companyImage.frame.size.width / 2)
        }
    }
    @IBOutlet weak var companyType: UILabel!
    {
        didSet{
            companyType.isSkeletonable = true
            companyType.layer.cornerRadius = 8
        }
    }
    
    var viewModel : CompanyViewModel!
    var jobs : [JobItemModel] = []
    var agents : [AgentModel] = []
    var currentAgents : [AgentModel] = []
    var isLoading: Bool = false
    var isExtentedMode: Bool = false
    var isVideoCalled: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isVideoCalled = false
    }
    
    private func startSkeletonAnimation(){
        
        self.tableView.isHidden = true
        self.skeletonView.isHidden = false
        
        skeletonView.sizeToFit()
        skeletonView.layoutIfNeeded()
        
        [pageTitle,
         companyMenuBtn,
         companyOptionBtn,
         backBtn,
         startInterviewBtn,
         companyName,
         companyImage,
         companyType,
         skeletonView2,
         skeletonView1,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6,
         skeletonView7,
         skeletonView9,
         skeletonView10,
         skeletonView11,
         skeletonView8,
         skeletonView12,
         skeletonView13,
         skeletonView14,
         skeletonView23,
         skeletonView24,
         skeletonView25,
         skeletonView26
        ].forEach({$0?.showAnimatedGradientSkeleton()})
    }
    
    private func stopSkeletonAnimation(){
        
        [pageTitle,
         companyMenuBtn,
         companyOptionBtn,
         backBtn,
         startInterviewBtn,
         companyName,
         companyImage,
         companyType,
         skeletonView2,
         skeletonView1,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6,
         skeletonView7,
         skeletonView9,
         skeletonView10,
         skeletonView11,
         skeletonView8,
         skeletonView12,
         skeletonView13,
         skeletonView14,
         skeletonView23,
         skeletonView24,
         skeletonView25,
         skeletonView26
        ].forEach({$0?.hideSkeleton()})
        
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.isHidden = false
        self.skeletonView.isHidden = true
        
    }
    
    func fetchingStatusChange(isFetching: Bool){
        
        isLoading = isFetching
        tableView.isUserInteractionEnabled = !isFetching
    }
    
    func bindData() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = CompanyViewModel.Input(menuTrigger: companyMenuBtn.rx.tap.asDriver(), optionTrigger: companyOptionBtn.rx.tap.asDriver(), loadTrigger: Driver.merge(viewWillAppear, pull), backTrigger: backBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.companyInfo.drive(CompanyBinding),output.backAction.drive(),output.menuAction.drive(),output.optionAction.drive(),
         output.error.drive(errorBinding),output.isFetching.drive(fetchingBinding)].forEach { (item) in
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
    
    var CompanyBinding: Binder<CompanyModel> {
        return Binder(self, binding: { (vc, company) in
           // let urlStr = BaseURL.dev.rawValue + "/" + (company.logoUrl ?? "")
            if let logoUrl = company.logoUrl, let url = URL(string: BaseURL.dev.rawValue + "/" + logoUrl) {
                self.companyImage.isHidden = false
                self.companyImage.kf.setImage(with: url)
                self.imageContainerView.backgroundColor = UIColor.clear
                self.imageContainerViewTitle.isHidden = true
            } else {
                self.companyImage.isHidden = true
                self.imageContainerView.backgroundColor = UIColor.random()
                self.imageContainerViewTitle.isHidden = false
                self.imageContainerViewTitle.text = company.name?.prefix(1).uppercased()
            }
            
            self.companyName.text = company.name
            self.companyType.text = company.aboutEn
            self.jobs = company.jobs ?? []
            self.agents = company.agents ?? []
            self.tableView.reloadData()
            
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

extension CompanyViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobsTableViewCell.reuseID) as! JobsTableViewCell
            cell.delegate = self
            cell.LoadingStatus(false)
            cell.bind(jobs)
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.reuseID) as! SpaceTableViewCell
            
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DescTableViewCell.reuseID) as! DescTableViewCell
            
            cell.viewMoreBtn.rx.controlEvent(UIControl.Event.touchUpInside).subscribe(onNext: { _ in
                self.isExtentedMode = !self.isExtentedMode
                self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
            }).disposed(by: disposeBag)
            
            let model = self.jobs.count > 0 ? self.jobs[0] : nil
            cell.bind(model?.descriptionEn ?? "")
            
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.reuseID) as! SpaceTableViewCell
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: AgentsTableViewCell.reuseID) as! AgentsTableViewCell
            cell.delegate = self
            cell.LoadingStatus(false)
            cell.bind(currentAgents)
            
            return cell
        default:
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 45
        case 1:
            return 10
        case 2:
            return self.isExtentedMode ? 180 : 110
        case 3:
            return 10
        case 4:
            return 500
            
        default:
            return UITableView.automaticDimension
        }
        
        
    }
    
    
}

extension CompanyViewController : JobSelectDelegate {
    func didSelectJob(model: JobItemModel){
        let cellDesc = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DescTableViewCell
        cellDesc.bind(model.descriptionEn ?? "")
        let agents = self.agents.filter({($0.jobs?.filter({$0.id == model.id}).count) != nil})
        self.currentAgents = agents
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .fade)
    }
}

extension CompanyViewController : AgentSelectDelegate {
    func didSelectAgent(model: AgentModel){
        
        if isVideoCalled == false {
            isVideoCalled = true
            self.viewModel.navigator.toVideoCall(roomModel: VideoRoomModel(agentId: model.id, agentName: model.name, agentPosition: model.position, roomName: model.roomId))
        }
    }
}



