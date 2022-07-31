//
//  SortingBottomViewController.swift
//  LibraryApp
//
//  Created by KC on 24/06/2022.
//

import UIKit

class SortingBottomViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelOne: UILabel!
   // @IBOutlet weak var shadowView: UIView!
    
    var sorting : Bool = true
    //var onViewOptionUpdated: ((ViewGrid) -> Void)?
    var onViewOptionUpdated:  ((Bool) -> Void)?



    init(sorting: Bool) {
        self.sorting = sorting
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDismiss)))
        
        
    }
    
    @objc func onTapDismiss(){
        //self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)

    }
    
    
    private func setupViews(){
        //shadowView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        //shadowView.backgroundColor = UIColor(white: 1, alpha: 0.2)

        labelOne.isUserInteractionEnabled = true
        labelThree.isUserInteractionEnabled = true
        labelTwo.isUserInteractionEnabled = true
        
        labelOne.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapOne)))
        labelTwo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapTwo)))
        labelThree.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapThree)))


        if sorting{
            labelTitle.text = "Sort by"
            labelOne.text = "Recently opened"
            labelTwo.text = "Title"
            labelThree.text = "Author"
        }
        else{
            labelTitle.text = "View as"
            labelOne.text = "List"
            labelTwo.text = "Large grid"
            labelThree.text = "Small grid"
        }
    }

   

    @objc func onTapOne() {
        if sorting {
            UDM.shared.defaults.setValue(SortingLibrary.recent.rawValue, forKey: "sorting")

        }
        else{
            UDM.shared.defaults.setValue(ViewGrid.list.rawValue, forKey: "view_as")
        }
        //self.navigationController?.popViewController(animated: false)
        onViewOptionUpdated!(sorting)
        self.dismiss(animated: true, completion: nil)

    }
    
    @objc func onTapTwo() {
        if sorting {
            UDM.shared.defaults.setValue(SortingLibrary.title.rawValue, forKey: "sorting")

        }
        else{
            UDM.shared.defaults.setValue(ViewGrid.large.rawValue, forKey: "view_as")
        }
        //self.navigationController?.popViewController(animated: false)
        onViewOptionUpdated!(sorting)
        self.dismiss(animated: true, completion: nil)

    }
    
    @objc func onTapThree() {
        if sorting {
            UDM.shared.defaults.setValue(SortingLibrary.author.rawValue, forKey: "sorting")

        }
        else{
            UDM.shared.defaults.setValue(ViewGrid.small.rawValue, forKey: "view_as")
        }
        onViewOptionUpdated!(sorting)
        self.dismiss(animated: false)
        //self.navigationController?.popViewController(animated: false)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
}
