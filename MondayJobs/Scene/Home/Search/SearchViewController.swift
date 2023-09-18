//
//  SearchViewController.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/20/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit
import SkeletonView

class SearchViewController: UIViewController {

    var rasterSize: CGFloat = 22.0
    let searchbarHeight: CGFloat = 44.0
    private var searchbar: Searchbar!
    private var maskMainView: UIView!
    private var dim: CGSize = .zero
    private let animHplr = AnimHelper.shared
    var layoutDelegate: SearchLayoutDelegate?
    var dataSource : [PanelModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dim = self.view.frame.size
        initUI()
       
    }
    
    func initUI(){

        // Configure searchbar
        searchbar = Searchbar(
            onStartSearch: {  (isSearching) in
               
                
            }, onClearInput: {},
            
            delegate: self
        )
       
        self.view.addSubViews([searchbar])
    }
    
    override func viewDidLayoutSubviews() {
        
        self.view.addConstraints([
            searchbar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 5),
            searchbar.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: rasterSize),
            searchbar.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -rasterSize),
            searchbar.heightAnchor.constraint(equalToConstant: searchbarHeight)
        ])

        searchbar.setHeightConstraint(0.07*dim.height)
        searchbar.setWidthConstraint(0.9*dim.width)


        self.view.layoutIfNeeded()
    }
    

}

extension SearchViewController: SearchbarDelegate {
    
    func searchbarTextDidChange(_ textField: UITextField) {
       
        
    }
    
    private func isTextInputValid(_ textField: UITextField) -> String? {
        if let keyword = textField.text, !keyword.isEmpty { return keyword }
        return nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layoutDelegate?.showSearchBar()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func searchbarTextShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
}
