//
//  AgentsTableViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/8/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit
import RxSwift

class AgentsTableViewCell: UITableViewCell,NibLoadableView  {

    @IBOutlet weak var agentTableTitle: UILabel!{
        didSet{
            agentTableTitle.textColor = UIColor.black.withAlphaComponent(0.6)
            agentTableTitle.font = Fonts.Regular.Regular12()
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(AgentViewCell.self)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.customStyle()
        }
    }
    var bag = DisposeBag()
    var dataSource : [AgentModel]?
    var isLoading : Bool = false
    var delegate: AgentSelectDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func LoadingStatus(_ isLoading : Bool){
        self.isLoading = isLoading
        tableView.reloadData()
    }
    
    func bind(_ agents: [AgentModel]){
        dataSource = agents
        tableView.reloadData()
    }
    
}

extension AgentsTableViewCell : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isLoading ? 4 : self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgentViewCell.reuseID, for: indexPath) as! AgentViewCell
        let model = dataSource?[indexPath.row]

        cell.callAgentBtn.rx.controlEvent(UIControl.Event.touchUpInside).subscribe(onNext: { _ in
            let model = self.dataSource?[indexPath.row]
            self.delegate?.didSelectAgent(model: model!)
        }).disposed(by: bag)
        
        cell.bind(model!)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
    }
    
    
}
