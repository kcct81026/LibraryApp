//
//  ViewController.swift
//  LibraryApp
//
//  Created by KC on 13/06/2022.
//

import UIKit
import Combine
import RxSwift
import SwiftUI


class HomeViewController: UIViewController {
    
    private var viewModel : HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var tableViewLibrary: UITableView!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        viewModel = HomeViewModel(bookModel: BookModelImpl.shared)
        bindViewState()

        viewModel.getEbookList()
        viewModel.getSliderBookList()
        
    }
    
    
    
    // MARK: BindViewState
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            //.print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendBookList:
                    self.tableViewLibrary.reloadData()
                case .sendAudioBookList:
                    self.tableViewLibrary.reloadData()

                case .sendSliderBookList:
                    self.tableViewLibrary.reloadData()

                }
                
            }.store(in: &cancellables)
    }
    
    // MARK: setupaTableView
    private func setupTableView(){
        tableViewLibrary.dataSource = self
        tableViewLibrary.allowsSelection = false
        tableViewLibrary.separatorStyle = .none
        tableViewLibrary.showsVerticalScrollIndicator = false
        tableViewLibrary.showsHorizontalScrollIndicator = false
        
        tableViewLibrary.registerForCell(identifier: SearchBooksTableViewCell.identifier)
        tableViewLibrary.registerForCell(identifier: HorizontalTableViewCell.identifier)
        tableViewLibrary.registerForCell(identifier: TapTableViewCell.identifier)
        tableViewLibrary.registerForCell(identifier: CategorySectionTableViewCell.identifier)
    }
    
    //MARK: Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.items[section]{
        
        case .CategoryList:
            if viewModel.bookList.isEmpty {
                return 0
            }
            else{
                return viewModel.bookList.count

            }
        default:
            return 1
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = viewModel.items[indexPath.section]
        switch itemType{
        case .SearchBook:
            let cell =  tableView.dequeueCell(identifier: SearchBooksTableViewCell.identifier, indexPath: indexPath) as SearchBooksTableViewCell
            cell.delegate = self
            return cell
        case .BookListSlider:
            let cell =  tableView.dequeueCell(identifier: HorizontalTableViewCell.identifier, indexPath: indexPath) as HorizontalTableViewCell
            cell.delegate = self
            cell.detailDelegate = self
            cell.data = viewModel.sliderBooks
            return cell
        case .TabTableView:
            let cell =  tableView.dequeueCell(identifier: TapTableViewCell.identifier, indexPath: indexPath) as TapTableViewCell
            cell.fromHome = true
            
            cell.onTapViewItemSelected = { [weak self] selectedItemType in
                guard let self = self else { return }
                switch selectedItemType {
                case .AudioBooks:
                    self.viewModel.getAudioList()

                case .Ebooks:
                    self.viewModel.getEbookList()

                }
            }
            
            return cell
        case .CategoryList:
            let cell =  tableView.dequeueCell(identifier: CategorySectionTableViewCell.identifier, indexPath: indexPath) as CategorySectionTableViewCell
            cell.data = viewModel.bookList[indexPath.row]
            cell.delegate = self
            cell.delegateSheet = self
            cell.detailDelegate = self
            return cell
        }
       
    }
    
}


// MARK: Delegate Extension
extension HomeViewController : OnTapMoreDelegate{
    func onTapMore(type: String, name: String) {
        navigateToMoreBookController(type: type, name: name)
    }
}

extension HomeViewController : BottomSheetDelegate{
    func onTapBottomSheet(id: String) {
       navigateHomeToBottomSheetController(id: id)
    }
    
}

extension HomeViewController : OnTapSearchDelegate{
    func onTapSearch() {
        navigateToSearchBooks()

    }
}

extension HomeViewController : onTapDetailDelegate {
    func onTapDetail(id: String) {
        navigateToDeailController(id: id)

    }
}
