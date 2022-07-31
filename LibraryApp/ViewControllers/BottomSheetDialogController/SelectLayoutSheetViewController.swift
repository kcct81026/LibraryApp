//
//  SelectLayoutSheetViewController.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import UIKit
import RxSwift
import Combine

class SelectLayoutSheetViewController: UIViewController {
    
    @IBOutlet weak var markAsReadSV: UIStackView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var aboutBookSV: UIStackView!
    @IBOutlet weak var addToWishListSV: UIStackView!
    @IBOutlet weak var freeSampleSV: UIStackView!
    @IBOutlet weak var addToShelfSV: UIStackView!
    @IBOutlet weak var deleteFromLibrarySV: UIStackView!
    @IBOutlet weak var downloadSV: UIStackView!
    
    private var bookModel : BookModel!
    private var viewModel : SelectLayoutViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    init(id: String){
        super.init(nibName: nil, bundle: nil)
        viewModel = SelectLayoutViewModel(bookModel: BookModelImpl.shared, libraryModel: LibraryModelImpl.shared)
        viewModel.id = id

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //setupPanGesture()
        
        setupViews()
       
        bindViewState()
        viewModel.getBookDettail()
        viewModel.checkBookInLibrary()
        
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapDismiss)))
        
        
    }
    
    @objc func onTapDismiss(){
        self.dismiss(animated: false)
       // self.navigationController?.popViewController(animated: true)

    
    }
    
    deinit{
        print("object is released")
    }
    
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            //.print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendBookDetail(let data) :
                    self.bookTitleLabel.text = data.title
                    self.authorLabel.text = data.author
                    self.bookImage.sd_setImage(with: URL(string: data.bookImage ?? ""))
                case .sendBookLibraryCheck(let data):
                    self.setupUI(check: data)
                case .deletedAction :
                    self.showAlert(message:  "Successfully removed from your library!"){ _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                case .savedToWishlist:
                    self.showAlert(message: "Added to wishlist!"){ _ in
                        self.dismiss(animated: true, completion: nil)
                    }

                }
                
            }.store(in: &cancellables)
    }
    
    private func setupViews(){
        deleteFromLibrarySV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapRemoveFromLibrary)))
        
        addToShelfSV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapAddToShelf)))
        
        addToWishListSV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapAddToWishlist)))
        
        aboutBookSV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapAboutBook)))
        
    }
    @objc func onTapAddToWishlist(){
        viewModel.addToWishList()
    }
    
    @objc func onTapAboutBook(){
        self.dismiss(animated: true)
        navigateToDeailController(id: viewModel.id )

    }
    
    @objc func onTapAddToShelf(){
        self.dismiss(animated: true)
        navigateShelfListViewController(id: viewModel.id )
    }
    
 
    @objc func onTapRemoveFromLibrary(){
        viewModel.deleteFromLibrary()
    }
    
    private func setupUI(check: Bool){
        if check {
            freeSampleSV.isHidden = true
            addToWishListSV.isHidden = true
            aboutBookSV.isHidden = true
            
        }
        else{
            downloadSV.isHidden = true
            deleteFromLibrarySV.isHidden = true
            addToShelfSV.isHidden = true
            markAsReadSV.isHidden = true
            
            freeSampleSV.isHidden = false
            addToWishListSV.isHidden = false
            aboutBookSV.isHidden = false
        }
    }

    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
        
     

    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
     
        if translation.y > 0{
            self.navigationController?.popViewController(animated: false)

//            if checkHome {
//                self.dismiss(animated: true, completion: nil)
//
//            }
//            else{
//                self.navigationController?.popViewController(animated: false)
//            }


        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)

        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }


}
