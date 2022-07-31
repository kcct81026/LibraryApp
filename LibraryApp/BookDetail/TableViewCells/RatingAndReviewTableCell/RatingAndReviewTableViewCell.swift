//
//  RatingAndReviewTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 21/06/2022.
//

import UIKit

class RatingAndReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var progressFive: UIProgressView!
    @IBOutlet weak var progressFour: UIProgressView!
    @IBOutlet weak var progressThree: UIProgressView!
    @IBOutlet weak var progressTwo: UIProgressView!
    @IBOutlet weak var progressOne: UIProgressView!
    @IBOutlet weak var imgNext: UIImageView!
    
    var onTapRatingAndReview: ((String) -> Void) = {_ in}

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
        //setUpRegisterCells()
        //setUpDataSourceAndDelegate()
    }
    
    var ratingClick : Bool? = nil {
        didSet{
            self.setupUI()
        }
    }
    
   


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupViews(){
        progressOne.transform = progressOne.transform.scaledBy(x: 1, y: 4)
        progressOne.layer.cornerRadius = 8
        progressOne.clipsToBounds = true
        progressOne.setProgress(0.05, animated: false)
        
        progressTwo.transform = progressTwo.transform.scaledBy(x: 1, y: 4)
        progressTwo.layer.cornerRadius = 8
        progressTwo.clipsToBounds = true
        progressTwo.setProgress(0.1, animated: false)

        progressThree.transform = progressThree.transform.scaledBy(x: 1, y: 4)
        progressThree.layer.cornerRadius = 8
        progressThree.clipsToBounds = true
        progressThree.setProgress(0.3, animated: false)

        progressFour.transform = progressFour.transform.scaledBy(x: 1, y: 4)
        progressFour.layer.cornerRadius = 8
        progressFour.clipsToBounds = true
        progressFour.setProgress(0.7, animated: false)

        progressFive.transform = progressFive.transform.scaledBy(x: 1, y: 4)
        progressFive.layer.cornerRadius = 8
        progressFive.clipsToBounds = true
        progressFive.setProgress(0.4, animated: false)
        
        setupUI()
     
    }
    
    private func setupUI(){
        if ratingClick ?? false {
            imgNext.isHidden = true
            labelTitle.isHidden = true
           
            labelTitleHeight.constant = 0
            
        }
        else{
            imgNext.isUserInteractionEnabled = true
            imgNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapReview)))
        }
        
            
    }
    

    
    @objc private func onTapReview(){
        self.onTapRatingAndReview("")
    }
    
}
    
