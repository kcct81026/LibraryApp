//
//  CommentCollectionViewCell.swift
//  LibraryApp
//
//  Created by KC on 22/06/2022.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var ratingControl : RatingControl!
    @IBOutlet weak var labelDate : UILabel!
    @IBOutlet weak var labelReview : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    private func setupViews(){
        labelReview.numberOfLines = 4
        labelReview.text = "This book is a amazing I truly enjoyed it, Author J. K. Rowling is my 3rd favorite author after Stephen king and his horrific story's and ideas love it and Jay Asher and his amazing book 13 reason why and I really suggest that one, but if you haven't read"
        
       
    }

}
