//
//  CommentTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 22/06/2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var viewPublisherHeight: NSLayoutConstraint!
    @IBOutlet weak var labelPublish: UILabel!
    @IBOutlet weak var publisherView: UIView!
    @IBOutlet weak var starCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var starCollectionView: UICollectionView!
    
    weak var delegate:OnSetCommentCount?=nil


    var ratingClick : Bool? = nil {
        didSet{
            self.setupUI()
        }
    }
    
    var book : Book? = nil {
        didSet{
            if let book = book {
                labelPublish.text = "\(book.createdDate ?? "" ) . \(book.publisher ?? "")"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setUpRegisterCells()
        setUpDataSourceAndDelegate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func setupUI(){
        if ratingClick ?? false {
            publisherView.isHidden = true
            starCollectionView.isHidden = false
            viewPublisherHeight.constant = 0
            starCollectionViewHeight.constant = 50
    
        }
        else{
            starCollectionView.isHidden = true
            starCollectionViewHeight.constant = 0
            publisherView.isHidden = false
        }
    
        
       
    }
    
   
    
    private func setUpRegisterCells(){
        starCollectionView.registerForCell(identifier: RatingStarCollectionViewCell.identifier)

    }

    private func setUpDataSourceAndDelegate(){
        starCollectionView.dataSource = self
        starCollectionView.delegate = self
    }
}

extension CommentTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 5

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: RatingStarCollectionViewCell.identifier, indexPath: indexPath) as RatingStarCollectionViewCell
        cell.data = indexPath.row
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = collectionView.frame.width / 6
        return CGSize(width: itemWidth, height: 50)


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == starCollectionView {
            self.delegate?.onSetCommentCount(count: indexPath.row + 1)
        }
    }


}
    
    

