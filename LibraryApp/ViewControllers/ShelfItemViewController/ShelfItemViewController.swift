//
//  ShelfItemViewController.swift
//  LibraryApp
//
//  Created by KC on 28/06/2022.
//

import UIKit
import Combine
import RxSwift


enum ShelfVCSectionType{
    case SortingAndGrid
    case WishListBookList
    case TitleShelf
}

class ShelfItemViewController: UIViewController {
    @IBOutlet weak var shelfTableView: UITableView!
    
    private var viewModel : ShelfViewModel!
    private var cancellables = Set<AnyCancellable>()

    
    private var disposeBag = DisposeBag()
 
    
    init(id: String , name: String ){
        viewModel = ShelfViewModel(libraryModel: LibraryModelImpl.shared)
        viewModel.id = id
        viewModel.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        bindViewState()
        viewModel.getBookList()
        
       
    }
    
    deinit{
        print("shlef item object is released!")
    }
    
    private func setupViews(){
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black

        let icon = UIImage(named: "setting_gray")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func handleClick(){
        navigateShelfBottomViewController(id: viewModel.id)
    }

   // MARK: BindViewState
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            //.print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendBookData:
                    if self.viewModel.bookSortingList.count > 0 {
                        self.viewModel.items = self.viewModel.bookItems
                    }
                    else{
                        self.viewModel.items = self.viewModel.noitems
                    }
                    self.shelfTableView.reloadData()
                }
               
            }.store(in: &cancellables)
    }
    
    
    // MARK: setupaTableView
    private func setupTableView(){
        shelfTableView.dataSource = self
        shelfTableView.allowsSelection = false
        shelfTableView.separatorStyle = .none
        shelfTableView.showsVerticalScrollIndicator = false
        shelfTableView.showsHorizontalScrollIndicator = false
        
        shelfTableView.registerForCell(identifier: SortingAndGridTableViewCell.identifier)
        shelfTableView.registerForCell(identifier: GridTableViewCell.identifier)
        shelfTableView.registerForCell(identifier: TitleShelfTableViewCell.identifier)

        

    }
    
    //MARK: Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getBookList()
        viewModel.setDefaultSortingAndGrid()
        super.viewWillAppear(animated)
    }
}

//MARK: - UITableViewDataSource
extension ShelfItemViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  viewModel.items.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = viewModel.items[indexPath.section]
        switch itemType{
 
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
        case .TitleShelf:
            let cell =  tableView.dequeueCell(identifier: TitleShelfTableViewCell.identifier, indexPath: indexPath) as TitleShelfTableViewCell
            
            cell.data = MyShelves(id: viewModel.id, shelfName: viewModel.name, books: viewModel.bookSortingList)
            return cell

        }

    }
    
}

extension ShelfItemViewController : onTapDetailDelegate {
    func onTapDetail(id: String) {
        navigateToDeailController(id: id)
    }
}

extension ShelfItemViewController : OnTapSortAndGird{
    func onTapSortAndGrid(sorting: Bool) {
        navigateSortingAndGridController(sorting: sorting) { sorting in 
            self.viewModel.setDefaultSortingAndGrid()
        }
    }
}

extension ShelfItemViewController : OnTapMoreDelegate{
    func onTapMore(type: String, name: String) {
        navigateToMoreBookController(type: type, name: name)
    }
}

extension ShelfItemViewController : BottomSheetDelegate{
    func onTapBottomSheet(id: String) {
       navigateHomeToBottomSheetController(id: id)
    }
    
}

