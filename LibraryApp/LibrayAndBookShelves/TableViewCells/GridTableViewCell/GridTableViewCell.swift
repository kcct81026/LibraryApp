//
//  GridTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 24/06/2022.
//

import UIKit

class GridTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    
    weak var delegate:OnTapMoreDelegate?=nil
    weak var detailDelegate:onTapDetailDelegate?=nil
    weak var delegateSheet:BottomSheetDelegate?=nil


    var gridType : String = ViewGrid.small.rawValue
    
    var data : [Book]? = nil {
        didSet{
            if let _ = data {
                setupRowHeight()
            }
        }
    }
    
    private func setupRowHeight(){
        if let list = data{
            var oneHeight = 0
            if gridType == ViewGrid.large.rawValue{
                if ( list.count % 2 == 0){
                    oneHeight = list.count / 2
                }
                else{
                    oneHeight =  ( list.count  / 2) + 1
                }
                collectionViewHeight.constant = CGFloat(oneHeight * 310)
            }
            else if gridType == ViewGrid.list.rawValue{
                
                collectionViewHeight.constant = CGFloat(list.count * 160)
            }
            else{
                if ( list.count % 3 == 0){
                    oneHeight = list.count / 3
                }
                else{
                    oneHeight =  ( list.count  / 3) + 1
                }
                collectionViewHeight.constant = CGFloat(oneHeight * 210)

            }
         
            
            bookCollectionView.reloadData()
        }
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
        bookCollectionView.registerForCell(identifier: BookCategoryCollectionViewCell.identifier)
        bookCollectionView.registerForCell(identifier: WishlistCollectionViewCell.identifier)

    }

    private func setUpDataSourceAndDelegate(){
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
    }
    
}

extension GridTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data?.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if gridType == ViewGrid.list.rawValue{
            let cell = collectionView.dequeueCell(identifier: WishlistCollectionViewCell.identifier, indexPath: indexPath) as WishlistCollectionViewCell
            cell.data = data?[indexPath.row]
            cell.onTapMore = { [weak self] data in
                guard let self = self else { return }
                self.delegateSheet?.onTapBottomSheet(id: data)
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueCell(identifier: BookCategoryCollectionViewCell.identifier, indexPath: indexPath) as BookCategoryCollectionViewCell
            cell.data = data?[indexPath.row]
            cell.fromLibrary = true
            cell.onTapMore = { [weak self] data in
                guard let self = self else { return }
                self.delegateSheet?.onTapBottomSheet(id: data)
            }
            return cell
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if gridType == ViewGrid.small.rawValue {
            let itemWidth : CGFloat = collectionView.frame.width / 3.2
      
            return CGSize(width: itemWidth, height: 200  )
        }
        else if gridType == ViewGrid.list.rawValue{
            
            let itemWidth : CGFloat = collectionView.frame.width
      
            return CGSize(width: itemWidth, height: 150  )
        }
        else{
            let itemWidth : CGFloat = collectionView.frame.width / 2.1
      
            return CGSize(width: itemWidth, height: 300  )
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.detailDelegate?.onTapDetail(id: data?[indexPath.row].primaryIsbn10 ?? "")
    }
    
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }

}
