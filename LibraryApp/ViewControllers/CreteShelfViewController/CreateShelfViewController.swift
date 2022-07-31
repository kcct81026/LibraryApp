//
//  CreateShelfViewController.swift
//  LibraryApp
//
//  Created by KC on 24/06/2022.
//

import UIKit

class CreateShelfViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var textFieldShelf: UITextField!
    
    var id: String = ""
    var shelfName: String = ""
    
    private var libraryModel : LibraryModel = LibraryModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        labelCount.text = "\(prospectiveText.count) / 50"
        return prospectiveText.count < 50
    }
    

    private func setupViews(){
//        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.setHidesBackButton(true, animated: true)
        let icon = UIImage(named: "check-tick")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        navigationItem.leftBarButtonItem = barButton
        
        if id.isEmpty{
            navigationItem.title = "Create shelf"

        }else{
            navigationItem.title = "Edit shelf"
            textFieldShelf.text = shelfName

        }
        
        textFieldShelf.delegate = self
    }
    
    @objc private func handleClick(){
        if !(textFieldShelf.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) {
            if id.isEmpty{
                libraryModel.saveShelf(name: textFieldShelf.text!){ [weak self] (result) in
                    guard let self = self else { return }
                    if result {
                        self.showAlert(message: "Created Shelf!"){_ in
                            
                            self.navigationController?.popViewController(animated: true)

                        }
                    }
                    else{
                        self.showInfo(message: "Shelf name shoudn't be the same!")
                    }
                    
                }
            }else{
                self.libraryModel.editShelf(id: self.id, updated: self.textFieldShelf.text!){ [weak self] result in
                    guard let self = self else { return }
                    if result{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                }


            }
        }
    }
   
    //MARK: Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    

    
}
