//
//  RatingStarCollectionViewCell.swift
//  LibraryApp
//
//  Created by KC on 22/06/2022.
//

import UIKit

class RatingStarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var labelStar: UILabel!
    
    var data : Int? = nil {
        didSet{
            if let data = data {
                labelStar.text = "\(data + 1)"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    private func setupViews(){
        view.addBorderColor(radius: 25, color: UIColor.lightGray.cgColor, borderWidth: 1)
       

    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                view.addBorderColor(radius: 25, color: UIColor.systemBlue.cgColor, borderWidth: 1)
                labelStar.textColor = .blue
                img.image = UIImage(named: "star_fill")
            }
            else{
                view.addBorderColor(radius: 25, color: UIColor.lightGray.cgColor, borderWidth: 1)
                labelStar.textColor = .gray
                img.image = UIImage(systemName: "star.fill")

            }
        }
    }

}
