//
//  BookSliderCollectionViewCell.swift
//  LibraryApp
//
//  Created by KC on 14/06/2022.
//

import UIKit

class BookSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewForShadow : UIView!
    @IBOutlet weak var viewShadowHandset : UIView!
    @IBOutlet weak var viewShadowCheck : UIView!
    @IBOutlet weak var bookImage : UIImageView!
    @IBOutlet weak var settingImg : UIImageView!
    
    var onTapMore: ((String) -> Void) = {_ in}
    
    var data : Book? = nil {
        didSet{
            if let data = data {
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
        bookImage.layer.cornerRadius = 15
        bookImage.clipsToBounds = true
        
        viewForShadow.backgroundColor = UIColor.black
        viewForShadow.clipsToBounds = true
        viewForShadow.layer.cornerRadius = 15
        viewForShadow.layer.masksToBounds = false
        viewForShadow.layer.shadowOpacity = 0.11
        viewForShadow.layer.shadowOffset = CGSize(width: 8, height:8)
        viewForShadow.layer.shadowColor = UIColor.black.cgColor
        
        viewShadowCheck.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewShadowHandset.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        viewShadowCheck.layer.cornerRadius = 8
        viewShadowHandset.layer.cornerRadius = 8
        viewShadowCheck.clipsToBounds = true
        viewShadowHandset.clipsToBounds = true
        settingImg.isUserInteractionEnabled = true
        settingImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBottomSheet)))

        
    }
    
    @objc func onTapBottomSheet(){
        if let id = data?.primaryIsbn10{
            onTapMore(id)

        }
    }

}
