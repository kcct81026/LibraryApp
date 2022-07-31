//
//  AddShelfItemTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 29/06/2022.
//

import UIKit

class AddShelfItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var labelBook: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var onTapCheck: (() -> Void) = {}

    
    var data : MyShelvesVO? = nil {
        didSet{
            if let data = data {
                labelTitle.text = data.shelfName
                if data.books.count > 0 {
                    labelBook.text = "\( data.books.count) books"
                    img.sd_setImage(with: URL(string: data.books.last?.bookImage ?? ""))

                }
                else{
                    img.image = UIImage(named: "no_book")
                    labelBook.text = "no book"
                }
                if data.isSelected == true {
                    imgCheckBox.image = UIImage(named: "check-box-select")
                } else {
                    imgCheckBox.image = UIImage(named: "check-box")
                }
                
                if data.alreadyAdded {
                    imgCheckBox.isUserInteractionEnabled = false
                }
                else{
                    imgCheckBox.isUserInteractionEnabled = true 
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        img.layer.cornerRadius = 10
        img.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imgCheckBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapButton)))
    }
    
    @objc func onTapButton(){
        if let data = data {
            data.isSelected = !data.isSelected
            onTapCheck()
        }
       
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
