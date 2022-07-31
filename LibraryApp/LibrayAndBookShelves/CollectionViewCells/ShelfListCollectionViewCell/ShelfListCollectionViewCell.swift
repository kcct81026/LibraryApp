//
//  ShelfListCollectionViewCell.swift
//  LibraryApp
//
//  Created by KC on 28/06/2022.
//

import UIKit

class ShelfListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelBooks: UILabel!
    @IBOutlet weak var labelShelfName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    var data : MyShelves? = nil {
        didSet{
            if let data = data {
                labelShelfName.text = data.shelfName
                if data.books?.count ?? 0  > 0{
                    img.sd_setImage(with: URL(string: data.books?.last?.bookImage ?? ""))
                    labelBooks.text = "\(data.books?.count ?? 0) books"
                }
                else{
                    img.image = UIImage(named: "no_book")
                    labelBooks.text = "no book"

                }
                
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        img.layer.cornerRadius = 10
        img.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

}
