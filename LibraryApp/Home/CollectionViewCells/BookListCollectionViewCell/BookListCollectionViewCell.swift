//
//  BookListCollectionViewCell.swift
//  LibraryApp
//
//  Created by KC on 20/06/2022.
//

import UIKit

class BookListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    var data : VolumeInfo? = nil {
        didSet{
            if let data = data {
                labelTitle.text = data.title
                labelType.text = data.printType
                img.sd_setImage(with: URL(string: (data.imageLinks?.smallThumbnail ?? data.imageLinks?.thumbnail) ?? ""))
                
                
                var authorsList = ""
                if let authors = data.authors {
                    authorsList = authors.joined(separator: ",")
                }
                labelAuthor.text = authorsList
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
    }
}
