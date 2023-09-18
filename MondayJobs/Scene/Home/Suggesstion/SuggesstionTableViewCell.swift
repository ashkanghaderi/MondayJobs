//
//  SuggesstionTableViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 11/17/20.
//  Copyright © 2020 Elinium. All rights reserved.
//

import UIKit

class SuggesstionTableViewCell: UITableViewCell,NibLoadableView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var suggesstionLabel: UILabel!
    
    var dataSource: [SuggesstionModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(SuggesstionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        suggesstionLabel.font = Fonts.Regular.Regular16()
        suggesstionLabel.textColor = AppColor.black
        suggesstionLabel.text =  NSLocalizedString("sugesstion_title", comment: "")
        suggesstionLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(model: [SuggesstionModel]){
        
        dataSource = model
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension SuggesstionTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggesstionViewCell.reuseID, for: indexPath) as! SuggesstionViewCell
        let model = dataSource[indexPath.item]
        cell.bind(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width / 2 , height: 200)
    }
    
}
