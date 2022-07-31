//
//  MoreBooksViewController.swift
//  LibraryApp
//
//  Created by KC on 17/06/2022.
//

import UIKit
import RxSwift
import Combine

class MoreBooksViewController: UIViewController {
    
    @IBOutlet weak var collectionViewMore : UICollectionView!

  
    private var bookModel : BookModel!
    private var viewModel : MoreBooksViewModel!
    private var cancellables = Set<AnyCancellable>()
 
    init(type: String, categoryName: String){
        viewModel = MoreBooksViewModel(bookModel: BookModelImpl.shared)
        viewModel.type = type
        viewModel.categoryName = categoryName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
        bindViewState()
        viewModel.fetchBooksByPage()
        
       

    }
    
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            //.print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendMoreBooks:
                    self.collectionViewMore.reloadData()

                }
                
            }.store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }
   
    
    
    private func setUpCollectionView(){
        navigationItem.title = viewModel.categoryName
        
        collectionViewMore.delegate = self
        collectionViewMore.dataSource = self
        collectionViewMore.registerForCell(identifier: BookCategoryCollectionViewCell.identifier)
        collectionViewMore.showsHorizontalScrollIndicator  = false
        collectionViewMore.showsVerticalScrollIndicator = false
        collectionViewMore.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)

        if let layout = collectionViewMore.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .vertical // .horizontal
        }
    
    }
    
    
}

extension MoreBooksViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: BookCategoryCollectionViewCell.identifier, indexPath: indexPath) as BookCategoryCollectionViewCell
        cell.data = viewModel.data[indexPath.row]
        cell.onTapMore = { data in
            self.navigateHomeToBottomSheetController(id: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing : CGFloat = (viewModel.itemSpacing * CGFloat(viewModel.numberOfItemsPerRow - 1)) + collectionView.contentInset.left + collectionViewMore.contentInset.right
        
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(viewModel.numberOfItemsPerRow)) - (totalSpacing / CGFloat(viewModel.numberOfItemsPerRow))
        let itemHeight : CGFloat = itemWidth * 1.5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        viewModel.handlePaganation(index: indexPath, type: viewModel.type)
    }
    
   
    
}
