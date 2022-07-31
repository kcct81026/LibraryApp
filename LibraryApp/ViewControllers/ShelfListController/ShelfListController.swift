//
//  ShelfListController.swift
//  LibraryApp
//
//  Created by KC on 29/06/2022.
//

import UIKit
import Combine

class ShelfListController: UIViewController {

    @IBOutlet weak var shelfListTableView: UITableView!
    
    var id: String = ""
    private var viewModel : ShelfListViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        viewModel = ShelfListViewModel(libraryModel: LibraryModelImpl.shared, bookModel: BookModelImpl.shared)
        bindViewState()
        viewModel.getShelvesList(id: id)

    }

    deinit{
        print("shlef list object is released!")
    }
    
    private func setupViews(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        let icon = UIImage(named: "check-tick")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = barButton
        
        navigationItem.title = "Add to Shelves"
    }
    
    @objc func handleClick(){
        viewModel.addBookToShelves(bookId: id)
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
                    self.shelfListTableView.reloadData()
                case .noItemAdded:
                    self.navigationController?.popViewController(animated: false)
                case .sendAddedAlert:
                    self.navigationController?.popViewController(animated: false)

                }
               
            }.store(in: &cancellables)
    }
    
    
    // MARK: setupaTableView
    private func setupTableView(){
        shelfListTableView.dataSource = self
        shelfListTableView.allowsSelection = false
        shelfListTableView.separatorStyle = .none
        shelfListTableView.showsVerticalScrollIndicator = false
        shelfListTableView.showsHorizontalScrollIndicator = false
        
        shelfListTableView.registerForCell(identifier: AddShelfItemTableViewCell.identifier)


    }
    
    //MARK: Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//MARK: - UITableViewDataSource
extension ShelfListController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.checkShelveList.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueCell(identifier: AddShelfItemTableViewCell.identifier, indexPath: indexPath) as AddShelfItemTableViewCell
        cell.data = self.viewModel.checkShelveList[indexPath.section]
        cell.onTapCheck = {
            self.viewModel.savingDataShelfList()
            
        }
        return cell
       

    }
    
}

