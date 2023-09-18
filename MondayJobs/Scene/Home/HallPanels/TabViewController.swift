//
//  TabViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import Foundation
import UIKit
import Tabman
import Pageboy

class TabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {

    // MARK: Properties
    var hallDataSource: [HallModel] = []
    
    var panelDelegate : PanelDelegate?
    /// View controllers that will be displayed in page view controller.
    private var viewControllers: [UIViewController]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index,hall) in hallDataSource.enumerated() {
            viewControllers?.append(HallPanelViewController(page: index,panels: hall.panels,pDelegate: self.panelDelegate!))
        }
        
        viewControllers?.forEach({$0.view.backgroundColor = UIColor.clear})
        // Set PageboyViewControllerDataSource dataSource to configure page view controller.
        dataSource = self
        
        
        
        // Create a bar
        let bar = TMBarView.ButtonBar()
        
        // Customize bar properties including layout and other styling.
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 4.0, right: 16.0)
        bar.layout.interButtonSpacing = 24.0
        bar.indicator.weight = .medium
        bar.indicator.cornerStyle = .eliptical
        bar.fadesContentEdges = true
        bar.spacing = 16.0
        

        // Set tint colors for the bar buttons and indicator.
        bar.buttons.customize {
            $0.tintColor = UIColor.black.withAlphaComponent(0.4)
            $0.selectedTintColor = AppColor.orange
            //$0.backgroundColor = AppColor.Steel
            $0.layer.cornerRadius = 12
            
        }
        bar.indicator.tintColor = AppColor.orange
        bar.indicator.layer.cornerRadius = 2
        
        // Add bar to the view - as a .systemBar() to add UIKit style system background views.
        
        bar.scrollMode = .swipe
        addBar(bar.systemBar(), dataSource: self, at: .top)
    }

    // MARK: PageboyViewControllerDataSource
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers?.count ?? 0
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers?[index] // View controller to display at a specific index for the page view controller.
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil // Default page to display in the page view controller (nil equals default/first index).
    }
    
    // MARK: TMBarDataSource
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: "\(hallDataSource[index].name!)") // Item to display for a specific index in the bar.
    }
}


