//
//  AboutBookTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 21/06/2022.
//

import UIKit

class AboutBookTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAboutBook: UILabel!
    @IBOutlet weak var imgBookDetailMore: UIImageView!
    
    var onTapDescriptin: ((Book) -> Void) = {_ in }

    
    var data : Book? = nil {
        didSet{
            if let data = data {
                labelAboutBook.text = data.bookDescription
                labelAboutBook.numberOfLines = 4
                labelAboutBook.lineBreakMode = .byWordWrapping
                
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBookDetailMore.isUserInteractionEnabled = true
        imgBookDetailMore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDescription)))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func onTapDescription(){
        if let data = data {
            self.onTapDescriptin(data)
        }
    }
    
}
