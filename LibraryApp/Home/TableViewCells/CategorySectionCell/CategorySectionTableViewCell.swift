//
//  CategorySectionTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 14/06/2022.
//

import UIKit

class CategorySectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var imgArrow : UIImageView!
    @IBOutlet weak var collectionViewBookList : UICollectionView!
    
    weak var delegate:OnTapMoreDelegate?=nil
    weak var detailDelegate:onTapDetailDelegate?=nil
    weak var delegateSheet:BottomSheetDelegate?=nil


    
    var data : BookList? = nil {
        didSet{
            if let data = data {
                label.text = data.displayName
                collectionViewBookList.reloadData()
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
        setUpRegisterCells()
        setUpDataSourceAndDelegate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpRegisterCells(){
        collectionViewBookList.registerForCell(identifier: BookCategoryCollectionViewCell.identifier)
    }

    private func setUpDataSourceAndDelegate(){
        collectionViewBookList.dataSource = self
        collectionViewBookList.delegate = self
    }
    
    
    private func setupViews(){
        imgArrow.isUserInteractionEnabled = true
        imgArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapMore)))
    }
    
    @objc private func onTapMore(){
        self.delegate?.onTapMore(type: data?.listNameEncoded ?? "", name: data?.displayName ?? "")
    }
    
    
}

extension CategorySectionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data?.books?.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: BookCategoryCollectionViewCell.identifier, indexPath: indexPath) as BookCategoryCollectionViewCell
        cell.data = data?.books?[indexPath.row]
        cell.fromLibrary = false
        cell.onTapMore = { data in
            self.delegateSheet?.onTapBottomSheet(id: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth : CGFloat = collectionView.frame.width / 3 
        //let itemHeight : CGFloat = collectionView.frame.height

        return CGSize(width: itemWidth, height: 250)
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
