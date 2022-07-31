//
//  CheckBox.swift
//  LibraryApp
//
//  Created by KC on 29/06/2022.
//

import Foundation
import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "check-box-select")! as UIImage
    let uncheckedImage = UIImage(named: "check-box")! as UIImage

    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
    
        self.addTarget(self, action: #selector(buttonClicked),  for: UIControl.Event.touchUpInside)

     

        self.isChecked = false
    }

   @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
