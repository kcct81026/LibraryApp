//
//  SearchBookViewController.swift
//  LibraryApp
//
//  Created by KC on 20/06/2022.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

class SearchBookViewController: UIViewController, UITextFieldDelegate {
    
 
    
    @IBOutlet weak var searchBookCollectionView: UICollectionView!
    
    private var cancellables = Set<AnyCancellable>()
    private let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!

  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = SearchViewModel()

        initViews()
        bindData()
    }
    
    private func initViews(){
        searchBar.placeholder = "Search Play Books"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.becomeFirstResponder()
        searchBar.barTintColor = .white
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = .black
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -20, vertical: 0), for: .search)
        
        navigationItem.titleView = searchBar
        

        registerViewCell()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    private func bindData() {
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addItemSelectedObserver()
        addPaginationObserver()
    }


    
    // MARK: setupCollectionView
    private func registerViewCell(){
        searchBookCollectionView.delegate = self
        searchBookCollectionView.registerForCell(identifier: BookListCollectionViewCell.identifier)
        searchBookCollectionView.showsHorizontalScrollIndicator  = false
        searchBookCollectionView.showsVerticalScrollIndicator = false
        
        searchBookCollectionView.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)

        if let layout = searchBookCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .vertical // .horizontal
        }
        
    }
    
   

}

//MARK: - Observers
extension SearchBookViewController {
    
    //MARK: - 1
    private func addSearchBarObserver() {
        // Search Text Field event listener
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .do(onNext: { print($0)})
            .subscribe(onNext: { value in
                self.viewModel.handleSearchInputText(text: value)
            })
            .disposed(by: disposeBag)
    }
    
    
    
    //MARK: - 4
    private func addCollectionViewBindingObserver() {
        // Bind Data to collection view cell
        viewModel.searchResultItems
            .bind(to: searchBookCollectionView.rx.items(
                    cellIdentifier: String(describing: BookListCollectionViewCell.self),
                    cellType: BookListCollectionViewCell.self))
            { row, element, cell in
                cell.data = element.volumeInfo
            }
            .disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver() {
        // On Item Selected
        // MARK: - 6
        searchBookCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self ] (indexPath) in
                guard let self = self else { return }
                let items = try! self.viewModel.searchResultItems.value()
                let element = items[indexPath.row]
                if let data = element.volumeInfo?.toBookVO(){
                    self.viewModel.saveBookAndAddToWishlist(data: data)
                    self.navigateToDeailController(id: data.primaryIsbn10 ?? "")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addPaginationObserver() {
        /// Pagination
        // MARK: - 5
        Observable.combineLatest(
            searchBookCollectionView.rx.willDisplayCell,
            searchBar.rx.text.orEmpty)
            .subscribe(onNext : { (cellTuple, searchText) in
                let (_, indexPath) = cellTuple
                self.viewModel.handlePaganation(index: indexPath, searchText: searchText)
            })
            .disposed(by: disposeBag)
    }
    
}


//MARK: - UICollectionViewDelegateFlowLayout
extension SearchBookViewController:UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing : CGFloat = (viewModel.itemSpacing * CGFloat(viewModel.numberOfItemsPerRow - 1)) + collectionView.contentInset.left + searchBookCollectionView.contentInset.right

        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(viewModel.numberOfItemsPerRow)) - (totalSpacing / CGFloat(viewModel.numberOfItemsPerRow))
       // let itemHeight : CGFloat = itemWidth * 1.8

        return CGSize(width: itemWidth, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.itemSpacing
        
    }
    


}


