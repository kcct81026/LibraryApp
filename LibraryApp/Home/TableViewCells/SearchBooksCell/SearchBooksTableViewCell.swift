//
//  SearchBooksTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 13/06/2022.
//

import UIKit

class SearchBooksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchView : UIView!
    weak var delegate:OnTapSearchDelegate?=nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    private func setupViews(){
        // corner radius
        searchView.layer.cornerRadius = 10

        // border
        searchView.layer.borderWidth = 0.3
        searchView.layer.borderColor = UIColor.gray.cgColor

        // shadow
        searchView.layer.shadowColor = UIColor.gray.cgColor
        searchView.layer.shadowOffset = CGSize(width: 3, height: 3)
        searchView.layer.shadowOpacity = 0.7
        searchView.layer.shadowRadius = 4.0
        
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSearch)))
    }
    
    @objc private func onTapSearch(){
        self.delegate?.onTapSearch()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
