//
//  HallPanelViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/13/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit

class HallPanelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(HallPanelTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.customStyle()
        }
    }
    var dataSource : [PanelModel] = []
    var scrollView: UIScrollView?
    var panelDelegate : PanelDelegate?
    var page: Int
    var refreshControl = UIRefreshControl()
    
    init(page: Int,panels: [PanelModel],pDelegate: PanelDelegate) {
        self.page = page
        dataSource = panels
        panelDelegate = pDelegate
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        panelDelegate?.didRefresh()
    }

}

extension HallPanelViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HallPanelTableViewCell.reuseID, for: indexPath) as! HallPanelTableViewCell
        let model = dataSource[indexPath.row]
        cell.bind(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        self.panelDelegate?.didSelectPanelItem(panel: model)
    }
    
}
