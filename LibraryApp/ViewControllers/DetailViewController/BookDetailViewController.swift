//
//  BookDetailViewController.swift
//  LibraryApp
//
//  Created by KC on 20/06/2022.
//

import UIKit
import Combine


enum BookDetailViewControllerSectionType{
    case BookInfoCell
    case BookActionSectionCell
    case BookDetailItemCell
    case RatingAndReviewItemCell
    case CommentSectionItemCell
    case PublisherCell
  
}

class BookDetailViewController: UIViewController {
    
    private var bookModel : BookModel!
    private var viewModel : BookDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var book: Book?

   
    @IBOutlet weak var tableViewDetail: UITableView!
    
    init(id: String){
        viewModel = BookDetailViewModel(bookModel: BookModelImpl.shared, id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit{
        print("object is realeasd!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupViews()
        setupTableView()
        bindViewState()

        fetchBookDetail()
    }
    
    private func fetchBookDetail(){
        viewModel.getBookDetail()
        viewModel.checkWatchList()
    }
    
     
    
    // MARK: BindViewState
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            //.print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendBookDetail(let data):
                    self.book = data
                case .removedFromWishList:
                    break
                case .addedToWishList :
                    break
                }
                self.tableViewDetail.reloadData()

                
            }.store(in: &cancellables)
    }
    
    // MARK: setupaTableView
    private func setupTableView(){
        tableViewDetail.dataSource = self
        tableViewDetail.allowsSelection = false
        tableViewDetail.separatorStyle = .none
        tableViewDetail.showsVerticalScrollIndicator = false
        tableViewDetail.showsHorizontalScrollIndicator = false
        
        tableViewDetail.registerForCell(identifier: BookInfoTableViewCell.identifier)
        tableViewDetail.registerForCell(identifier: BookActionItemCell.identifier)
        tableViewDetail.registerForCell(identifier: AboutBookTableViewCell.identifier)
        tableViewDetail.registerForCell(identifier: RatingAndReviewTableViewCell.identifier)
        tableViewDetail.registerForCell(identifier: CommentTableViewCell.identifier)
        tableViewDetail.registerForCell(identifier: CommentSectionTableViewCell.identifier)


    }
    
    private func setupViews(){
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }

    
}

//MARK: - UITableViewDataSource
extension BookDetailViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = viewModel.items[indexPath.section]
        switch itemType{
        case .BookInfoCell:
            let cell =  tableView.dequeueCell(identifier: BookInfoTableViewCell.identifier, indexPath: indexPath) as BookInfoTableViewCell
            cell.data = book
            return cell
        case .BookActionSectionCell:
            let cell =  tableView.dequeueCell(identifier: BookActionItemCell.identifier, indexPath: indexPath) as BookActionItemCell
            cell.data = viewModel.isAddedBookMark
            cell.onTapWishList = { [weak self] in
                guard let self = self else { return }
                self.viewModel.toggleTapWishList()
                
            }
            return cell
        case .BookDetailItemCell:
            let cell =  tableView.dequeueCell(identifier: AboutBookTableViewCell.identifier, indexPath: indexPath) as AboutBookTableViewCell
            cell.data = book
            cell.onTapDescriptin = { [weak self] data in
                guard let self = self else { return }
                self.navigateToBookDescriptionController(book: data)
            }
            return cell
            
        case .RatingAndReviewItemCell:
            let cell =  tableView.dequeueCell(identifier: RatingAndReviewTableViewCell.identifier, indexPath: indexPath) as RatingAndReviewTableViewCell
            cell.ratingClick = false
            cell.onTapRatingAndReview = { [weak self] data in
                guard let self = self else { return }
                self.navigateToRatingController(id: self.book?.primaryIsbn10 ?? "")
            }
            return cell
            
        case .PublisherCell:
            let cell =  tableView.dequeueCell(identifier: CommentTableViewCell.identifier, indexPath: indexPath) as CommentTableViewCell
            cell.ratingClick = false
            cell.book = book
            return cell
        case .CommentSectionItemCell:
            let cell =  tableView.dequeueCell(identifier: CommentSectionTableViewCell.identifier, indexPath: indexPath) as CommentSectionTableViewCell
            return cell
        }
       
    }
    
}
