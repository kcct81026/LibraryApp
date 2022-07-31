//
//  SortingAndGridTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 23/06/2022.
//

import UIKit
import SwiftUI

class SortingAndGridTableViewCell: UITableViewCell {

    @IBOutlet weak var imgGrid: UIImageView!
    @IBOutlet weak var labelSorting: UILabel!
    @IBOutlet weak var imgSorting: UIImageView!
    
    var data : String? = nil {
        didSet{
            if let data = data {
                if data == SortingLibrary.recent.rawValue{
                    labelSorting.text = "Sort by: Recent"
                }
                else if data == SortingLibrary.title.rawValue{
                    labelSorting.text = "Sort by: Title"
                }
                else {
                    labelSorting.text = "Sort by: Author"
                }
            }
        }
    }
    weak var delegate:OnTapSortAndGird?=nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    private func setupViews(){
        
         
        imgGrid.isUserInteractionEnabled = true
        imgGrid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapGrid)))
        imgSorting.isUserInteractionEnabled = true
        imgSorting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSorting)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func onTapGrid(){
        delegate?.onTapSortAndGrid(sorting: false)
    }
    
    @objc func onTapSorting(){
        delegate?.onTapSortAndGrid(sorting: true)
    }
    
}
