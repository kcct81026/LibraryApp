//
//  LibraryViewController.swift
//  LibraryApp
//
//  Created by KC on 23/06/2022.
//

import UIKit
import Combine
import RxSwift
import SwiftUI
import RxCocoa


  
class LibraryVeiwController: UIViewController {
    
    private var viewModel : LibraryViewModel!
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var labelNoItem: UILabel!
    @IBOutlet weak var labelNoItemTitle: UILabel!
    @IBOutlet weak var noShelves: UIView!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var tableViewLibrary: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        viewModel = LibraryViewModel(libraryModel: LibraryModelImpl.shared)
        bindViewState()
        viewModel.getWishListBooks()

       
    }
    
    
    private func setupViews(){
        shadowView.backgroundColor = UIColor.black
        shadowView.clipsToBounds = true
        shadowView.layer.cornerRadius = 30
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.11
        shadowView.layer.shadowOffset = CGSize(width: 8, height:8)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        
        createView.layer.cornerRadius = 30
        createView.clipsToBounds = true
        createView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCreateShelf)))
        
        shadowView.isHidden = true
        noShelves.isHidden = true
    }
    
    @objc func onTapCreateShelf(){
        navigateCreateShelfController()
    }
    
    
   
    
    
    // MARK: BindViewState
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            //.print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendShelvesData:
                    self.setupShelvesList()
                case .sendBookData:
                    self.setupWishList()
                }
                
                self.tableViewLibrary.reloadData()
            }.store(in: &cancellables)
    }
    
    private func setupWishList(){
        if viewModel.bookSortingList.count > 0 {
            viewModel.items = viewModel.booksItems
            shadowView.isHidden = true
            noShelves.isHidden = true
        }
        else{
            shadowView.isHidden = true
            noShelves.isHidden = false
            viewModel.items = viewModel.noshelves
            labelNoItem.text = "Create your book list to match the way you think!"
            labelNoItemTitle.text = "No Books"
        }
    }
    
    private func setupShelvesList(){
        if viewModel.shelvesList.count > 0{
            viewModel.items = viewModel.shelfItems
            self.noShelves.isHidden = true


        }else{
            self.noShelves.isHidden = false
            viewModel.items = viewModel.noshelves
            self.labelNoItem.text = "Create your shelves to match the way you think!"
            self.labelNoItemTitle.text = "No shelves"
        }
        
        self.shadowView.isHidden = false


       
    }
    
    
  
    // MARK: setupaTableView
    private func setupTableView(){
        tableViewLibrary.dataSource = self
        tableViewLibrary.allowsSelection = false
        tableViewLibrary.separatorStyle = .none
        tableViewLibrary.showsVerticalScrollIndicator = false
        tableViewLibrary.showsHorizontalScrollIndicator = false
        
        tableViewLibrary.registerForCell(identifier: SearchBooksTableViewCell.identifier)
        tableViewLibrary.registerForCell(identifier: TapTableViewCell.identifier)
        tableViewLibrary.registerForCell(identifier: SortingAndGridTableViewCell.identifier)
        tableViewLibrary.registerForCell(identifier: GridTableViewCell.identifier)
        tableViewLibrary.registerForCell(identifier: ShelfTableViewCell.identifier)


    }
    
    //MARK: Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if UDM.shared.defaults.string(forKey: "tap") == TapBooksAndShelves.shelf.rawValue{
            viewModel.getShelvesList()
        }
        else{
            viewModel.setDefaultSortingAndGrid()
        }
     
    }
}

//MARK: - UITableViewDataSource
extension LibraryVeiwController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = viewModel.items[indexPath.section]
        switch itemType{
        case .SearchBook:
            let cell =  tableView.dequeueCell(identifier: SearchBooksTableViewCell.identifier, indexPath: indexPath) as SearchBooksTableViewCell
            cell.delegate = self
            return cell
       
        case .TabTableView:
            let cell =  tableView.dequeueCell(identifier: TapTableViewCell.identifier, indexPath: indexPath) as TapTableViewCell
            cell.fromHome = false
            cell.onTapViewItemSelected = { [weak self] selectedItemType in
                guard let self = self else { return }
                switch selectedItemType {
                case .AudioBooks:
                    self.viewModel.getShelvesList()
                    break
                case .Ebooks:
                    self.viewModel.getWishListBooks()
                    
                    break
                }
            }
            
            return cell
        case .SortingAndGrid:
            let cell =  tableView.dequeueCell(identifier: SortingAndGridTableViewCell.identifier, indexPath: indexPath) as SortingAndGridTableViewCell
            cell.data = viewModel.sorting
            cell.delegate = self 
            return cell
        case .WishListBookList:
            let cell =  tableView.dequeueCell(identifier: GridTableViewCell.identifier, indexPath: indexPath) as GridTableViewCell
            cell.gridType = viewModel.viewAs
            cell.data = viewModel.bookSortingList
            cell.detailDelegate = self
            cell.delegate = self
            cell.delegateSheet = self
            return cell
        case .ShelvesList:
            let cell =  tableView.dequeueCell(identifier: ShelfTableViewCell.identifier, indexPath: indexPath) as ShelfTableViewCell
            cell.data = viewModel.shelvesList
            cell.delegate = self
            return cell
        }
       
    }
    
}


// MARK: Delegate Extension
extension LibraryVeiwController : OnTapMoreDelegate{
    func onTapMore(type: String, name: String) {
        navigateToMoreBookController(type: type, name: name)
    }
}

extension LibraryVeiwController : BottomSheetDelegate{
    func onTapBottomSheet(id: String) {
       navigateHomeToBottomSheetController(id: id)
    }
    
}

extension LibraryVeiwController : OnTapSearchDelegate{
    func onTapSearch() {
        navigateToSearchBooks()

    }
}

extension LibraryVeiwController : onTapDetailDelegate {
    func onTapDetail(id: String) {
        navigateToDeailController(id: id)
    }
}

extension LibraryVeiwController : OnTapSortAndGird{
    
    func onTapSortAndGrid(sorting: Bool) {
            navigateSortingAndGridController(sorting: sorting) { viewGrid in
                self.viewModel.setDefaultSortingAndGrid()
            }
        }
}

extension LibraryVeiwController : OnTapBookShelfItem{
    func onTapBookShelfItem(id: String, name: String) {
        
        navigateToShelfItemViewController(id: id , name: name)
    }
}
