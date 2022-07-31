//
//  TitleShelfTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 29/06/2022.
//

import UIKit

class TitleShelfTableViewCell: UITableViewCell {

    @IBOutlet weak var labeltitle: UILabel!
    @IBOutlet weak var labelBook: UILabel!
    
    var data : MyShelves? = nil {
        didSet{
            if let data = data {
                labeltitle.text = data.shelfName
                if data.books?.count ?? 0 > 0 {
                    labelBook.text = "\( data.books?.count ?? 0) books"
            
                    

                }
                else{
                    labelBook.text = "no book"
                }
                
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
