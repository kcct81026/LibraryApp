//
//  BookActionItemCell.swift
//  LibraryApp
//
//  Created by KC on 21/06/2022.
//

import UIKit

class BookActionItemCell: UITableViewCell {

    @IBOutlet weak var labelBookMark: UILabel!
    @IBOutlet weak var imgBookMark: UIImageView!
    @IBOutlet weak var bookMarkView: UIView!
    @IBOutlet weak var freeSampleView: UIView!
    
    var onTapWishList: (() -> Void) = { }
    
    var data : Bool? = nil {
        didSet{
            if let data = data {
                if data {
                    imgBookMark.image = UIImage(named: "remove-bookmark-white")
                    labelBookMark.text = "Remove from wishlist"
                }else{
                    imgBookMark.image =  UIImage(named: "bookmark_white")
                    labelBookMark.text = "Add to wishlist"
                }
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupViews(){
        freeSampleView.addBorderColor(radius: 8, color: UIColor.lightGray.cgColor, borderWidth: 1)
        bookMarkView.layer.cornerRadius = 8
        bookMarkView.clipsToBounds = true
        
        labelBookMark.isUserInteractionEnabled = true
        labelBookMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBookMark)))
        
    }
    
    @objc func onTapBookMark(){
        //onTapWishList(data)
        onTapWishList()
    }
    
}
