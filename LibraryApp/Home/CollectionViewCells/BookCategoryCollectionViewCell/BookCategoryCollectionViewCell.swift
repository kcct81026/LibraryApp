//
//  BookCategoryCollectionViewCell.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import UIKit
import SDWebImage

class BookCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewCheck: UIView!
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var viewForShadow : UIView!
    @IBOutlet weak var bookImage : UIImageView!
    @IBOutlet weak var settingImg : UIImageView!
    @IBOutlet weak var label : UILabel!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    var onTapMore: ((String) -> Void) = {_ in}
    
    var fromLibrary : Bool = false
    
    
    var data : Book? = nil {
        didSet{
            if let data = data {
                label.text = data.title
                bookImage.sd_setImage(with: URL(string: data.bookImage ?? ""))
                
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpShadow()
    }
    
    private func setUpShadow(){

        bookImage.layer.cornerRadius = 8
        bookImage.clipsToBounds = true
        
        viewForShadow.backgroundColor = UIColor.black
        viewForShadow.clipsToBounds = true
        viewForShadow.layer.cornerRadius = 8
        viewForShadow.layer.masksToBounds = false
        viewForShadow.layer.shadowOpacity = 0.11
        viewForShadow.layer.shadowOffset = CGSize(width: 4, height:4)
        viewForShadow.layer.shadowColor = UIColor.black.cgColor
        
        viewCheck.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewSample.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        viewCheck.layer.cornerRadius = 8
        viewSample.layer.cornerRadius = 8
        viewCheck.clipsToBounds = true
        viewSample.clipsToBounds = true
        
        settingImg.isUserInteractionEnabled = true
        settingImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBottomSheet)))
        
        if fromLibrary {
            viewCheck.isHidden = false
            viewSample.isHidden = false
            
        }
        else{
            viewCheck.isHidden = true
            viewSample.isHidden = true
        }

        
    }
    
    @objc func onTapBottomSheet(){
        if let id = data?.primaryIsbn10{
            onTapMore(id)

        }
    }


}
