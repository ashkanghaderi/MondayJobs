//
//  JobsTableViewCell.swift
//  MondayJobs
//
//  Created by Ashkan Ghaderi on 1/8/21.
//  Copyright © 2021 Elinium. All rights reserved.
//

import UIKit

class JobsTableViewCell: UITableViewCell,NibLoadableView  {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(jobDescViewCell.self)
        }
    }
    
    var dataSource : [JobItemModel]?
    var isLoading : Bool = false
    var delegate: JobSelectDelegate?
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
        collectionView.reloadData()
    }
    
    func bind(_ jobs: [JobItemModel]){
        dataSource = jobs
        collectionView.reloadData{
            DispatchQueue.main.async {
                if let dSource = self.dataSource,dSource.count > 0 {
                    self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .bottom)
                    self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
                }
            }
        }
    }
    
}

extension JobsTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isLoading ? 3 : self.dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: jobDescViewCell.reuseID, for: indexPath) as! jobDescViewCell
        let model = dataSource?[indexPath.item]
       
            
        cell.bind(model!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = self.dataSource?[indexPath.item].titleEn
        let font = Fonts.Regular.Regular15()
        let size = string?.widthWithConstrainedHeight(30, font: font) ?? 60

        return CGSize(width: size + 30, height: 42)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource?[indexPath.item]
        self.delegate?.didSelectJob(model: model!)
    }
   
}
