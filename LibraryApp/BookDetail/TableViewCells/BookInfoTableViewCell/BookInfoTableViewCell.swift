//
//  BookInfoTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 20/06/2022.
//

import UIKit

class BookInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelAuthor : UILabel!
    @IBOutlet weak var labelPages : UILabel!
    
    var data : Book? = nil {
        didSet{
            if let data = data {
                labelTitle.text = data.title
                img.sd_setImage(with: URL(string: data.bookImage ?? ""))
                labelAuthor.text = data.author
                labelPages.text = "Ebook . 187 pages"
                
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
