//
//  ShelfTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 28/06/2022.
//

import UIKit

class ShelfTableViewCell: UITableViewCell {

    @IBOutlet weak var shelfCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shelfCollectionView: UICollectionView!
    
    weak var delegate:OnTapBookShelfItem?=nil

    
    var data : [MyShelves]? = nil {
        didSet{
            if let _ = data {
                setupRowHeight()
            }
        }
    }
    
    private func setupRowHeight(){
        shelfCollectionViewHeight.constant = CGFloat( (data?.count ?? 0 ) * 150)
        shelfCollectionView.reloadData()
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpRegisterCells()
        setUpDataSourceAndDelegate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpRegisterCells(){
        shelfCollectionView.registerForCell(identifier: ShelfListCollectionViewCell.identifier)

    }

    private func setUpDataSourceAndDelegate(){
        shelfCollectionView.dataSource = self
        shelfCollectionView.delegate = self
    }
    
}

extension ShelfTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data?.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueCell(identifier: ShelfListCollectionViewCell.identifier, indexPath: indexPath) as ShelfListCollectionViewCell
        cell.data = data?[indexPath.row]
        
        return cell
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth : CGFloat = collectionView.frame.width
  
        return CGSize(width: itemWidth, height: 140  )
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.onTapBookShelfItem(id: data?[indexPath.row].id ?? "", name: data?[indexPath.row].shelfName ?? "")
    }
    
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }

}
