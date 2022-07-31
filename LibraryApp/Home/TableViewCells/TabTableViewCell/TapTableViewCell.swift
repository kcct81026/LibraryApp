//
//  TapTableViewCell.swift
//  LibraryApp
//
//  Created by KC on 18/06/2022.
//

import UIKit

class TapTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewEbookLine : UIView!
    @IBOutlet weak var viewAudioLine: UIView!
    
    @IBOutlet weak var labelEbook : UILabel!
    @IBOutlet weak var labelAudio: UILabel!
    
    var onTapViewItemSelected: ((SelectedItemType) -> Void) = {_ in}
    

    var fromHome: Bool? = nil{
        didSet{
            if fromHome ?? false{
                labelAudio.text = "Audio Books"
                labelEbook.text = "Ebooks"
                
            }else{
                labelAudio.text = "Your shelves"
                labelEbook.text = "Your books"
                if UDM.shared.defaults.string(forKey: "tap") == TapBooksAndShelves.book.rawValue{
                    labelEbook.textColor = UIColor.systemBlue
                    labelAudio.textColor = UIColor.gray
                    viewEbookLine.backgroundColor = UIColor.systemBlue
                    viewAudioLine.backgroundColor = UIColor.white
                }
                else{
                    labelEbook.textColor = UIColor.gray
                    labelAudio.textColor = UIColor.systemBlue
                    viewEbookLine.backgroundColor = UIColor.white
                    viewAudioLine.backgroundColor = UIColor.systemBlue
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
        labelEbook.isUserInteractionEnabled = true
        labelAudio.isUserInteractionEnabled = true
        labelAudio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapAudioBook)))
        labelEbook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapEBook)))
        
       

    }
    
    @objc private func onTapEBook(){
        labelEbook.textColor = UIColor.systemBlue
        labelAudio.textColor = UIColor.gray
        viewEbookLine.backgroundColor = UIColor.systemBlue
        viewAudioLine.backgroundColor = UIColor.white
        onTapViewItemSelected(.Ebooks)
    }
    
    @objc private func onTapAudioBook(){
        labelEbook.textColor = UIColor.gray
        labelAudio.textColor = UIColor.systemBlue
        viewEbookLine.backgroundColor = UIColor.white
        viewAudioLine.backgroundColor = UIColor.systemBlue
        onTapViewItemSelected(.AudioBooks)
    }
    
}
