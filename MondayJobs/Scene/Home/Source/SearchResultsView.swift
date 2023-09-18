//
//  SearchResultsView.swift
//  MaterialDesignSearchbar
//
//  Created by Ho, Tsung Wei on 7/12/19.
//  Copyright © 2019 Ho, Tsungwei. All rights reserved.
//

import UIKit
import CoreLocation
import RxGesture
import RxSwift

protocol seaerchResultSelectionDelegate {
    func didSelectResult(model: PanelModel)
}
/**
 The state of the tableView used in SearchResultsView.
 */
enum State {
   
    case loading
   
    case populated([PanelModel])
  
    case empty
   
    case error(Error)

    var Panels: [PanelModel] {
        switch self {
        case .populated(let panel):
            return panel
        default:
            return []
        }
    }
}

class SearchResultsView: UIView {
    // MARK: - UI widgets
    private var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    private var activityIndicator: MaterialLoadingIndicator!
    private var loadingView: UIView!
    private var emptyView: UIView!
    private var noResultLabel: UILabel!
    private var errorView: UIView!
    private var errorLabel: UILabel!
    // MARK: - Private properties
    private var cellId = "ResultCell"
    private var didSelectAction: DidSelectLocation?
    // MARK: - Public properties
    public var rowHeight: CGFloat = 60.0
    public var isScrolling = false
    var bag = DisposeBag()
    /**
     The current state of the tableView. Reload the tableView every time the state is changed.
     */
    var state = State.loading {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.setFooterView()
                // Reload table with animations
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
            }
        }
    }
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    /**
     Convenience initializer for app use.
     
     - Parameter didSelectAction: Handle when user select an item in the search results view.
     */
    convenience init(didSelectAction: DidSelectLocation) {
        self.init()
        self.didSelectAction = didSelectAction
    }
    /**
     Init UI.
     */
    private func initUI() {
        self.setCornerBorder()
        self.backgroundColor = UIColor.clear
        prepareTableView()
        // Set up loading view
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.rowHeight))
        
        activityIndicator = MaterialLoadingIndicator()
        loadingView.addSubViews([activityIndicator])
        // Set up empty view
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.rowHeight))
        
        noResultLabel = UILabel(title: "No results! Try searching for something else.", size: 17.0, color: .gray, lines: 3, aligment: .center)
        emptyView.addSubViews([noResultLabel])
        // Set up error view
        errorView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.rowHeight))
        
        errorLabel = UILabel(title: "There is an error.", size: 17.0, color: .gray, lines: 3, aligment: .center)
        errorView.addSubViews([errorLabel])
    }
    // layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingView.centerSubView(activityIndicator)
        errorLabel.leftAnchor.constraint(equalTo: errorView.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: errorView.rightAnchor).isActive = true
        errorView.centerSubView(errorLabel)
        noResultLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor).isActive = true
        noResultLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor).isActive = true
        emptyView.centerSubView(noResultLabel)
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    /**
     Set up tableView and add to parent view.
     */
    private func prepareTableView() {
        tableView = UITableView()
        (tableView.delegate, tableView.dataSource, tableView.separatorStyle, tableView.keyboardDismissMode) = (self, self, .singleLine, .onDrag)
        tableView.register(ResultCell.self)
        tableView.isUserInteractionEnabled = true
        tableView.canCancelContentTouches = false
        tableView.backgroundColor = UIColor.clear
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        self.addSubViews([tableView])
    }
   
    func update(newPanels: [PanelModel]?, error: Error?) {
        if let error = error {
            state = .error(error)
            return
        }
        guard let newPanels = newPanels, !newPanels.isEmpty else {
            state = .empty
            return
        }
        state = .populated(newPanels)
    }
    /**
     Change footer view based on current state.
     */
    func setFooterView() {
        switch state {
        case .error(let error):
            errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .loading:
            activityIndicator.startAnimating()
            tableView.tableFooterView = loadingView
        case .empty:
            tableView.tableFooterView = emptyView
        case .populated:
            tableView.tableFooterView = nil
        }
    }
    // Required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate
extension SearchResultsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(state.Panels.count, 10)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.reuseID) as? ResultCell else {
            return UITableViewCell()
        }
        
        
//        cell.containerView.rx.tapGesture().subscribe(onNext: { _ in
//            if let onSelect = self.didSelectAction, indexPath.row < self.state.Panels.count {
//                onSelect!(self.state.Panels[indexPath.row])
//            }
//        }).disposed(by: bag)
        cell.configure(state.Panels[indexPath.row],delegate: self)
        return cell
    }
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSelect = self.didSelectAction, indexPath.row < state.Panels.count {
            onSelect!(state.Panels[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
    }
}

extension SearchResultsView : seaerchResultSelectionDelegate{
    func didSelectResult(model: PanelModel) {
        if let onSelect = self.didSelectAction {
            onSelect!(model)
        }
    }
    
    
}



