//
//  ShlefBottomDialogController.swift
//  LibraryApp
//
//  Created by KC on 28/06/2022.
//

import UIKit
import Combine
import RxSwift

class ShlefBottomDialogController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var svDelete: UIStackView!
    @IBOutlet weak var svRename: UIStackView!
    @IBOutlet weak var labelTitle: UILabel!
    
    private var bookModel : BookModel!
    private var viewModel : ShelfBottomDialogViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    var onShelfDeleted : (() -> Void)?
    var onShelfEdited : (() -> Void)?

    
    //    var onViewOptionUpdated:  ((Bool) -> Void)?




    deinit{
        print(" shelf object is realased!")
    }
    
    init(id: String){
        viewModel = ShelfBottomDialogViewModel(libraryModel: LibraryModelImpl.shared)
        viewModel.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewState()

        viewModel.getShelfBookByID(id: viewModel.id)
        setupViews()

        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDismiss)))
        
        
    }
    
    @objc func onTapDismiss(){
        self.dismiss(animated: false)
       // self.navigationController?.popViewController(animated: true)

    
    }
    private func setupViews(){
        svDelete.isUserInteractionEnabled = true
        svRename.isUserInteractionEnabled = true
        svDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteShelf)))
        svRename.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(renameShelf)))
        
//        shadowView.backgroundColor = UIColor.gray
//        shadowView.clipsToBounds = true
//        shadowView.layer.masksToBounds = false
//        shadowView.layer.shadowOpacity = 0.11
//        shadowView.layer.shadowOffset = CGSize(width: 8, height:8)
//        shadowView.layer.shadowColor = UIColor.gray.cgColor
    }
    
    @objc func deleteShelf(){
        viewModel.deleteBookShelf(id: viewModel.id)
    }
    
    @objc func renameShelf(){
        self.dismiss(animated: true) {
            self.onShelfEdited?()

        }

        navigateCreateShelfController(id: viewModel.id, shelfName: viewModel.myShelf?.shelfName ?? "")
    }
    
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            //.print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendShelfData :
                    self.labelTitle.text = self.viewModel.myShelf?.shelfName
                case .sendDeleteAlert (let result):
                    if result {
                        self.showAlert(message: "Successfully deleted!"){_ in
                            //self.navigationController?.popViewController(animated: true)
                            self.onShelfDeleted?()
                            self.dismiss(animated: true)
//                            self.dismiss(animated: true, completion: {
//                                self.navigationController?.viewControllers = self.navigationController?.viewControllers.filter{
//                                    !($0 is ShelfItemViewController)
//                                } ?? [UIViewController]()
//                            })
                          
                        
                        }
                        
                     
                    }

                }
                
            }.store(in: &cancellables)
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
