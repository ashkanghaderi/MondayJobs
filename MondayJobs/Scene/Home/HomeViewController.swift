//
//  HomeViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/12/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import SHSearchBar
import RxSwift
import RxCocoa
import Domain
import RxGesture
import SkeletonView
import NetworkPlatform
import Lottie
import AVKit
import AVFoundation
import EventKit


protocol SearchLayoutDelegate {
    func showSearchBar()
    func hideSearchBar()
}

protocol PanelDelegate {
    func didSelectPanelItem(panel: PanelModel)
    func didRefresh()
}

public typealias doRefreshAction = () -> Void

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var skeletonView: UIView!{
        didSet{
            skeletonView.isHidden = true
            skeletonView.backgroundColor = UIColor.white
        }
    }
    @IBOutlet weak var skeletonView1: UIView!{
        didSet{
            skeletonView1.isSkeletonable = true
            skeletonView1.skeletonCornerRadius = 12
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
            skeletonView3.skeletonCornerRadius = 12
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
            skeletonView8.skeletonCornerRadius = 12
        }
    }
    
    @IBOutlet weak var skeletonView9: UIView!{
        didSet{
            skeletonView9.isSkeletonable = true
            skeletonView9.skeletonCornerRadius = 12
        }
    }
    
    
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var offlineExhibitionView: UIView!{
        didSet{
            offlineExhibitionView.isHidden = true
        }
    }
    @IBOutlet weak var offlineTitleLabel: UILabel!{
        didSet{
            offlineTitleLabel.font = Fonts.Regular.Regular17()
        }
    }
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var notifyByEmailTitle: UILabel!{
        didSet{
            notifyByEmailTitle.font = Fonts.Regular.Regular15()
        }
    }
    @IBOutlet weak var notifyByEmailSwitch: UISwitch!{
        didSet{
            notifyByEmailSwitch.isSelected = false
        }
    }
    @IBOutlet weak var setRemainderTitle: UILabel!{
        didSet{
            setRemainderTitle.font = Fonts.Regular.Regular15()
        }
    }
    @IBOutlet weak var setRemainderSwitch: UISwitch!{
        didSet{
            setRemainderSwitch.isSelected = false
        }
    }
    @IBOutlet weak var notificationContainerView: UIView!{
        didSet{
            notificationContainerView.isSkeletonable = true
            notificationContainerView.skeletonCornerRadius = Float(notificationContainerView.frame.size.width / 2)
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(TimerTableViewCell.self)
            tableView.register(TitleTableViewCell.self)
            tableView.register(SearchTableViewCell.self)
            tableView.register(SuggesstionTableViewCell.self)
            tableView.register(TabTableViewCell.self)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.customStyle()
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var notificationBtn: UIButton!{
        didSet{
            notificationBtn.isSkeletonable = true
            notificationBtn.skeletonCornerRadius = Float(notificationBtn.frame.size.width / 2)
        }
    }
    @IBOutlet weak var userImageContainerLabel: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var userImageContainer: BorderedView!{
        didSet{
            userImageContainer.isSkeletonable = true
            userImageContainer.skeletonCornerRadius = Float(userImageContainer.frame.size.width / 2)
        }
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!{
        didSet{
            userName.isSkeletonable = true
            userName.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var userJobTitle: UILabel!{
        didSet{
            userJobTitle.isSkeletonable = true
            userJobTitle.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var notificationAnimationView: UIView!
    
    
    var hallDataSource: [HallModel] = []
    var panels: [PanelModel] = []
    var suggesstionDataSource: [SuggesstionModel] = []
    var viewModel: HomeViewModel!
    var panelPage : TabViewController?
    var isRunning: Bool = true
    private var animationView: AnimationView?
    var rasterSize: CGFloat = 22.0
    let searchbarHeight: CGFloat = 44.0
    private var searchbar: Searchbar!
    private var maskMainView: UIView!
    private var searchResultsView: SearchResultsView!
    private var dim: CGSize = .zero
    private let animHplr = AnimHelper.shared
    private var incompletedReminders: [EKReminder]?
    var searchBarShouldShow : Bool = false
    var isLoading: Bool = false
    public static var doRefresh : doRefreshAction = {}
    
    var timeEnd : Date?
    var header : HeaderView?
    var player: AVPlayer?
    var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer?
    var reminder: EKReminder!
    var exhibitionDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dim = self.view.frame.size
        initSearchUI()
        setupUI()
        bindData()
        
        SoketManager.shared.connect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(companyAvailable),name: .companyAvailableNotificationName, object: nil)
        
        // Observe end
//        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.queuePlayer = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    @objc func companyAvailable(notification: NSNotification) {
        
        animationView?.play()
        
    }
    
    private func startSkeletonAnimation(){
        
        tableView.isHidden = true
        skeletonView.isHidden = false
        notificationAnimationView.isHidden = true
        skeletonView.sizeToFit()
        skeletonView.layoutIfNeeded()
        
        [notificationBtn,
         notificationContainerView,
         userImageContainer,
         userName,
         userJobTitle,
         skeletonView1,
         skeletonView2,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6,
         skeletonView7,
         skeletonView8,
         skeletonView9
        ].forEach({$0?.showAnimatedGradientSkeleton()})
    }
    
    private func stopSkeletonAnimation(){
        
        tableView.isHidden = false
        skeletonView.isHidden = true
        notificationAnimationView.isHidden = false
        [notificationBtn,
         notificationContainerView,
         userImageContainer,
         userName,
         userJobTitle,
         skeletonView1,
         skeletonView2,
         skeletonView3,
         skeletonView4,
         skeletonView5,
         skeletonView6,
         skeletonView7,
         skeletonView8,
         skeletonView9
        ].forEach({$0?.hideSkeleton()})
        
    }
    
    func addTimerView(){
        
        let height = (self.timerContainerView.frame.width * 9)/16
        
        header = HeaderView(frame: CGRect(x:0, y: 0,width : self.timerContainerView.frame.width, height : height))
        header!.backgroundColor = UIColor.clear
        self.timerContainerView.removeSubviews()
        self.timerContainerView.addSubview(header!)
        
        header!.translatesAutoresizingMaskIntoConstraints = false
        
        self.timerContainerView.addConstraint(NSLayoutConstraint(item: header!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.timerContainerView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        self.timerContainerView.addConstraint(NSLayoutConstraint(item: header!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.timerContainerView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        self.timerContainerView.addConstraint(NSLayoutConstraint(item: header!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.timerContainerView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        self.timerContainerView.addConstraint(NSLayoutConstraint(item: header!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.timerContainerView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        
        header!.layoutIfNeeded()
        
        updateView()
        
    }
    
    func updateView() {
        // Initialize the label
        setTimeLeft()
        
        // Start timer
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setTimeLeft), userInfo: nil, repeats: true)
    }
    
    
    @objc func setTimeLeft() {
        let timeNow = Date()
        
        
        if timeEnd?.compare(timeNow) == ComparisonResult.orderedDescending {
            
            let interval = timeEnd?.timeIntervalSince(timeNow)
            
            let days =  (interval! / (60*60*24)).rounded(.down)
            
            let daysRemainder = interval?.truncatingRemainder(dividingBy: 60*60*24)
            
            let hours = (daysRemainder! / (60 * 60)).rounded(.down)
            
            let hoursRemainder = daysRemainder?.truncatingRemainder(dividingBy: 60 * 60).rounded(.down)
            
            let minites  = (hoursRemainder! / 60).rounded(.down)
            
            let minitesRemainder = hoursRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            
            let scondes = minitesRemainder?.truncatingRemainder(dividingBy: 60).rounded(.down)
            
            
            header?.DaysProgress.setProgress(days/360, animated: false)
            header?.hoursProgress.setProgress(hours/24, animated: false)
            header?.minitesProgress.setProgress(minites/60, animated: false)
            header?.secondesProgress.setProgress(scondes!/60, animated: false)
            
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 2
            
            header?.valueDay.text = formatter.string(from: NSNumber(value:days))
            header?.valueHour.text = formatter.string(from: NSNumber(value:hours))
            header?.valueMinites.text = formatter.string(from: NSNumber(value:minites))
            header?.valueSeconds.text = formatter.string(from: NSNumber(value:scondes!))
            
            
            
        } else {
            header?.fadeOut()
            viewDidAppear(true)
        }
    }
    
    func initSearchUI(){
        
        maskMainView = UIView()
        // maskMainView.backgroundColor = .white
        
        // Configure searchbar
        searchbar = Searchbar(
            onStartSearch: { [weak self] (isSearching) in
                guard let self = self else { return }
                self.showSearchResultsView(isSearching)
            },
            onClearInput: { [weak self] in
                guard let self = self else { return }
                self.searchResultsView.state = .populated([])
                
            },
            delegate: self
        )
        
        // Configure searchResultsView
        searchResultsView = SearchResultsView(didSelectAction: { [weak self] (panel) in
            guard let self = self else { return }
            self.didSelectPanel(panel)
        })
        
        showSearchResultsView(false)
        
        searchbar.isHidden = true
        
        self.containerView.addSubViews([maskMainView , searchResultsView, searchbar])
    }
    
    override func viewDidLayoutSubviews() {
        maskMainView.setConstraintsToView(top: self.containerView, bottom: self.containerView, left: self.containerView, right: self.containerView)
        
        self.containerView.addConstraints([
            searchbar.topAnchor.constraint(equalTo: self.containerView.layoutMarginsGuide.topAnchor, constant: 20),
            searchbar.leadingAnchor.constraint(equalTo: self.containerView.layoutMarginsGuide.leadingAnchor, constant: rasterSize),
            searchbar.trailingAnchor.constraint(equalTo: self.containerView.layoutMarginsGuide.trailingAnchor, constant: -rasterSize),
            searchbar.heightAnchor.constraint(equalToConstant: searchbarHeight)
        ])
        searchResultsView.setConstraintsToView(top: containerView,tConst: 80,bottom: containerView, left: searchbar, right: searchbar)
        searchbar.setHeightConstraint(0.07*dim.height)
        searchbar.setWidthConstraint(0.9*dim.width)
        
        self.containerView.layoutIfNeeded()
    }
    
    func setupUI(){
        
        userName.font = Fonts.Bold.Bold14()
        userName.textColor = AppColor.black
        
        self.userImageContainerLabel.font = Fonts.Bold.Bold18()
        self.userImageContainerLabel.textColor = UIColor.white
        
        userJobTitle.font = Fonts.Regular.Regular11()
        userJobTitle.textColor = AppColor.black.withAlphaComponent(0.4)
        
        userImageContainer.layer.borderWidth = 1.0
        userImageContainer.layer.masksToBounds = false
        userImageContainer.layer.borderColor = AppColor.Steel.cgColor
        userImageContainer.layer.cornerRadius = userImageContainer.frame.size.width / 2
        userImageContainer.clipsToBounds = true
        
        animationView = .init(name: "notification_ring")
        
        animationView!.frame = notificationContainerView.bounds
        
        animationView!.contentMode = .scaleAspectFit
        
        animationView!.loopMode = .loop
        
        animationView!.animationSpeed = 0.5
        
        notificationContainerView.addSubview(animationView!)
        
        notificationContainerView.bringSubviewToFront(notificationBtn)
        
        setRemainderSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
    }
    
    func bindData() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        //let refresh = Driver.of(HomeViewController.doRefresh())
        
        
        let input = HomeViewModel.Input(NotificationTrigger: notificationBtn.rx.tap.asDriver(),viewWillAppearTrigger:  viewWillAppear, profileTrigger: profileBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        [output.NotificationAction.do(onNext: { [weak self] _ in
            self?.animationView?.stop()
        }).drive(),output.profileAction.drive(),
        
        output.suggesstions.do(onNext: {(exhibition) in
            DispatchQueue.main.async {
                
                self.suggesstionDataSource = exhibition
                self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: UITableView.RowAnimation.none)
                
            }
            
        } ).drive(),
        
        output.jobTitle.drive(userJobTitle.rx.text),output.userName.drive(userName.rx.text),output.imageUrl.drive(avatarBinding),output.exhibition.do(onNext: { (exhibition) in
            DispatchQueue.main.async {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                self.exhibitionDate = dateFormatterGet.date(from: "\(String(describing: exhibition.date)) 10:00:00")
                
                self.isRunning = false//exhibition.isRunning ?? true
                if self.isRunning == true {
                    self.tableView.isHidden = false
                    self.notificationContainerView.isHidden = false
                    self.offlineExhibitionView.isHidden = true
                    self.hallDataSource = exhibition.halls ?? []
                    for hall in self.hallDataSource{
                        for panel in hall.panels {
                            self.panels.append(panel)
                        }
                    }
                    self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: UITableView.RowAnimation.none)
                } else {
                    self.tableView.isHidden = true
                    self.offlineExhibitionView.isHidden = false
                    self.notificationContainerView.isHidden = true
                    
                    self.timeEnd = Date(timeInterval: "2021-02-25 10:00:00".toDate(format: "yyyy-MM-dd HH:mm:ss").timeIntervalSince(Date()), since: Date())
                    
                    self.addTimerView()
                    
                    if let videoUrl = Bundle.main.url(forResource: "PeopleWalking", withExtension: "mp4") {
                        // Init video
                        
                        let asset: AVAsset = AVAsset(url: videoUrl)
                        let playerItem = AVPlayerItem(asset: asset)
                        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
                        
                        self.queuePlayer?.isMuted = true
                        self.queuePlayer?.actionAtItemEnd = .none
                        
                        // Add player layer
                        let playerLayer = AVPlayerLayer(player: self.queuePlayer)
                        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                        playerLayer.frame = self.offlineExhibitionView.frame
                        
                        // Add video layer
                        playerLayer.removeFromSuperlayer()
                        self.offlineExhibitionView.layer.insertSublayer(playerLayer, at: 0)
                        
                        self.playerLooper = AVPlayerLooper(player: self.queuePlayer!, templateItem: playerItem)
                        
                        // Play video
                        self.queuePlayer?.play()
                        
                        
                        
                    }
                    else {
                        
                        print("NoFile")
                    }
                }
                
                self.updateUserInfo(userAvatar: AuthorizationInfo.get(by: "avatarUrl"),jobTitle: AuthorizationInfo.get(by: "jobTitle"))
                
                
                
            }
            
        } ).drive(),output.error.drive(errorBinding),output.isFetching.drive(fetchingBinding)].forEach { (item) in
            item.disposed(by: disposeBag)
        }
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        if value == true {
            if ReminderManager.shared.isAccessGranted {
                fetchReminders()
            } else {
                ReminderManager.shared.requestAccess { [unowned self] granted in
                    if granted {
                        self.fetchReminders()
                    }
                }
            }
        } else {
            removeReminder()
        }
    }
    
    private func fetchReminders() {
        ReminderManager.shared.fetchReminders { [unowned self] reminders in
            DispatchQueue.main.async {
                self.incompletedReminders = reminders?.filter { $0.isCompleted == false && $0.title == "MondayJob exhibition event" }
                if let reminders = self.incompletedReminders , reminders.count > 0 {
                    self.reminder = reminders[0]
                } else {
                    createReminder()
                }
            }
        }
    }
    
    private func dateComponents(from date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
    }
    
    private func changeReminder() {
        reminder.isCompleted = !reminder.isCompleted
        ReminderManager.shared.saveReminder(self.reminder)
    }

    private func removeReminder() {
        if self.reminder != nil {
            ReminderManager.shared.removeReminder(self.reminder)
        }
    }
    
    private func createReminder() {
        if let date = self.exhibitionDate {
            self.reminder = ReminderManager.shared.createReminder()
            self.reminder.title = "MondayJob exhibition event"
            
            addAlarmToReminder(date)
            ReminderManager.shared.saveReminder(self.reminder)
        }
    }
    
    private func addAlarmToReminder(_ date: Date) {
        let alarm = EKAlarm(absoluteDate: date)

        reminder.addAlarm(alarm)
        reminder.dueDateComponents = dateComponents(from: date)
    }
    
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            if let eError = error as? EliniumError{
                vc.ShowSnackBar(snackModel: SnackModel(title: eError.localization , duration: 5))
            }
        })
    }
    
    var avatarBinding: Binder<String> {
        return Binder(self, binding: { (vc, url) in
            //self.userImageView.image = UIImage(named: "person")
            
            self.updateUserInfo(userAvatar: url)
            
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
    
    private func updateUserInfo(userAvatar: String?,jobTitle: String? = nil){
        if let usrAvatar = userAvatar {
            let urlStr = BaseURL.dev.rawValue + "/" + usrAvatar
            if let url = URL(string: urlStr) {
                self.userImageView.isHidden = false
                self.userImageView.kf.setImage(with: url)
                self.userImageContainer.backgroundColor = UIColor.clear
                self.userImageContainerLabel.isHidden = true
            } else {
                self.userImageView.isHidden = true
                self.userImageContainer.backgroundColor = UIColor.random()
                self.userImageContainerLabel.isHidden = false
                self.userImageContainerLabel.text = self.userName.text?.prefix(1).uppercased()
            }
            
        } else {
            self.userImageView.isHidden = true
            self.userImageContainer.backgroundColor = UIColor.random()
            self.userImageContainerLabel.isHidden = false
            self.userImageContainerLabel.text = self.userName.text?.prefix(1).uppercased()
        }
        
        self.userJobTitle.text = jobTitle
    }
    
    private func showSearchResultsView(_ show: Bool) {
        if show {
            self.searchResultsView.isHidden = false
            guard maskMainView.alpha == 0.0 else { return }
            animHplr.moveUpViews([maskMainView,searchResultsView], show: true)
        } else {
            animHplr.moveDownViews([maskMainView,searchResultsView], show: false)
            searchResultsView.isScrolling = false
            DispatchQueue.main.async {
                self.searchbar.isHidden = true
                self.searchResultsView.isHidden = true
                self.searchbar.setBtnStates(hasInput: false, isSearching: false)
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
            
        }
    }
    
    func didSelectPanel(_ panel: PanelModel) {
        if let id = panel.companyId {
            showSearchResultsView(false)
            searchbar.setBtnStates(hasInput: false, isSearching: false)
            segueToCompany(id: id)
        }
    }
    
    func segueToCompany(id: String){
        
        self.viewModel.navigator.toCompanyPage(id: id)
        
    }
    
}

extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseID) as! TitleTableViewCell
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID) as! SearchTableViewCell
            
            
            
            cell.contentView.removeSubviews()
            
            let searchPage =  SearchViewController(nibName: "SearchViewController", bundle: nil)
            
            
            
            self.addChild(searchPage)
            cell.contentView.addSubview(searchPage.view)
            
            searchPage.view.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addConstraint(NSLayoutConstraint(item: searchPage.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: searchPage.view!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: searchPage.view!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: searchPage.view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
            
            searchPage.didMove(toParent: self)
            searchPage.view.layoutIfNeeded()
            
            searchPage.layoutDelegate = self
            
            
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggesstionTableViewCell.reuseID) as! SuggesstionTableViewCell
            
            cell.bind(model: suggesstionDataSource)
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: TabTableViewCell.reuseID) as! TabTableViewCell
            cell.layoutIfNeeded()
            cell.contentView.removeSubviews()
            
            let panelPage =  TabViewController(nibName: "TabViewController", bundle: nil)
            panelPage.panelDelegate = self
            panelPage.hallDataSource = hallDataSource
            self.addChild(panelPage)
            cell.contentView.addSubview(panelPage.view)
            
            panelPage.view.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addConstraint(NSLayoutConstraint(item: panelPage.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: panelPage.view!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: panelPage.view!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
            cell.contentView.addConstraint(NSLayoutConstraint(item: panelPage.view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
            
            panelPage.didMove(toParent: self)
            panelPage.view.layoutIfNeeded()
            
            return cell
        default:
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 80
        case 2:
            return 0
        case 3:
            return self.view.bounds.height - 120
            
        default:
            return UITableView.automaticDimension
        }
        
        
    }
    
    
}

extension HomeViewController : SearchLayoutDelegate {
    func showSearchBar() {
        
        DispatchQueue.main.async {
            
            self.searchBarShouldShow = true
            self.searchbar.isHidden = false
            
            self.tableView.isHidden = true
            
            self.searchbar.textInput.becomeFirstResponder()
        }
    }
    
    func hideSearchBar() {
        
        
    }
    
    
}

extension HomeViewController: SearchbarDelegate {
    
    func searchbarTextDidChange(_ textField: UITextField) {
        guard let keyword = isTextInputValid(textField) else { return }
        searchResultsView.state = .loading
        searchPanels(keyword)
    }
    
    private func isTextInputValid(_ textField: UITextField) -> String? {
        if let keyword = textField.text, !keyword.isEmpty { return keyword }
        return nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showSearchResultsView(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard !searchResultsView.isScrolling else { return }
        showSearchResultsView(false)
        searchbar.setBtnStates(hasInput: textField.text?.count != 0, isSearching: false)
        
    }
    
    func searchbarTextShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = isTextInputValid(textField) else { return false }
        searchPanels(keyword, completion: { [weak self] (panel, error) in
            guard let self = self, let first = panel.first else { return }
            self.didSelectPanel(first)
        })
        return true
    }
    
    private func searchPanels(_ keyword: String, completion: (([PanelModel], Error?) -> Void)? = nil) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchPanels(query: keyword).subscribe(onNext: { panels in
                DispatchQueue.main.async {
                    
                    self.searchResultsView.update(newPanels: panels, error: nil)
                    completion?(panels, nil)
                }
            }, onError:{ error in
                DispatchQueue.main.async {
                    self.searchResultsView.update(newPanels: [], error: error)
                    completion?([], error)
                }
            } ).disposed(by: self.disposeBag)
            
        }
    }
}

extension HomeViewController : PanelDelegate {
    
    func didSelectPanelItem(panel: PanelModel) {
        if let id = panel.companyId {
            self.segueToCompany(id: id)
        }
    }
    func didRefresh() {
        HomeViewController.doRefresh()
    }
}




