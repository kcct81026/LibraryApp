//
//  CommentSectionTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 22/06/2022.
//

import UIKit

class CommentSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var labelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelDescription.numberOfLines = 4
        labelDescription.text = "This book is a amazing I truly enjoyed it, Author J. K. Rowling is my 3rd favorite author after Stephen king and his horrific story's and ideas love it and Jay Asher and his amazing book 13 reason why and I really suggest that one, but if you haven't read"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
