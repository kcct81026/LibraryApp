//
//  HorizontalTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 13/06/2022.
//

import UIKit
import UPCarouselFlowLayout

class HorizontalTableViewCell: UITableViewCell{
    
    @IBOutlet weak var collectionViewBookList : UICollectionView!
    weak var delegate:BottomSheetDelegate?=nil
    weak var detailDelegate:onTapDetailDelegate?=nil
    
    var data : BookList? = nil {
        didSet{
            if let _ = data {
                collectionViewBookList.reloadData()
                
            }
        }
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpRegisterCells()
        setUpDataSourceAndDelegate()
        setColletionViewHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpRegisterCells(){
        collectionViewBookList.registerForCell(identifier: BookSliderCollectionViewCell.identifier)
    }

    private func setUpDataSourceAndDelegate(){
        collectionViewBookList.dataSource = self
        collectionViewBookList.delegate = self
    }
    
    private func setColletionViewHeight(){
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
        layout.itemSize = CGSize(width: 250, height: 250)
        collectionViewBookList.collectionViewLayout = layout
       
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionViewBookList.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 0)
    }
    
    

    
}

extension HorizontalTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.books?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: BookSliderCollectionViewCell.identifier, indexPath: indexPath) as BookSliderCollectionViewCell
        cell.onTapMore  = { data in
            self.delegate?.onTapBottomSheet(id: data)
        }
        cell.data = data?.books?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.detailDelegate?.onTapDetail(id: data?.books?[indexPath.row].primaryIsbn10 ?? "")
    }
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//
//        visibleRect.origin = collectionViewBookList.contentOffset
//        visibleRect.size = collectionViewBookList.bounds.size

//let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

//        guard let indexPath = collectionViewBookList.indexPathForItem(at: visiblePoint) else { return }
        //currentCard = self.cardList[indexPath.row]

    }

    
}

