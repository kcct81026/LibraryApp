//
//  WishlistCollectionViewCell.swift
//  LibraryApp
//
//  Created by KC on 24/06/2022.
//

import UIKit

class WishlistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgBottomShett: UIImageView!
    @IBOutlet weak var img: UIImageView!
    
    var onTapMore: ((String) -> Void) = {_ in}
    
    var data : Book? = nil {
        didSet{
            if let data = data {
                labelTitle.text = data.title
                img.sd_setImage(with: URL(string: data.bookImage ?? ""))
                labelAuthor.text = data.author
                
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgBottomShett.isUserInteractionEnabled = true
        imgBottomShett.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBottomSheet)))
    }
    
    @objc func onTapBottomSheet(){
        if let id = data?.primaryIsbn10{
            onTapMore(id)

        }
    }


}
