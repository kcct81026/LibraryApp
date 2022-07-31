//
//  BookDescriptionViewController.swift
//  LibraryApp
//
//  Created by KC on 22/06/2022.
//

import UIKit

class BookDescriptionViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationUI()
    }
    
    private func setupUI(){
        labelTitle.text = book?.bookDescription
        labelDescription.text = book?.bookDescription
        
    }
    
    private func setupNavigationUI(){
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = book?.title
    }


}
