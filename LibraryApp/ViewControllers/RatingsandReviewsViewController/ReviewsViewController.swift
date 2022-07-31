//
//  ReviewsViewController.swift
//  LibraryApp
//
//  Created by KC on 22/06/2022.
//

import UIKit
import Combine


enum ReviewContorllerSectionType{
    case RatingAndReviewItemCell
    case CommentSectionItemCell
    case RatingListItemCell
}

class ReviewsViewController: UIViewController {

    @IBOutlet weak var ratingTableView: UITableView!
   
    
    private var bookModel : BookModel!
    private var viewModel : BookDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var book: Book?
    var id: String = ""
    
    private var commentCount : Int? = nil {
        didSet{
            items.removeAll()
            items.append(.RatingAndReviewItemCell)
            items.append(.RatingListItemCell)
            for _ in 0..<(commentCount ?? 3) {
                items.append(.CommentSectionItemCell)
            }
            ratingTableView.reloadData()
        }
    }
    
    var items : [ReviewContorllerSectionType] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        viewModel = BookDetailViewModel(bookModel: BookModelImpl.shared, id: id)
        bindViewState()
        self.commentCount = 3
        fetchBookDetail()
    }
    
    private func fetchBookDetail(){
        viewModel.getBookDetail()
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
                self.ratingTableView.reloadData()

            }.store(in: &cancellables)
    }
    
    // MARK: setupaTableView
    private func setupTableView(){
        ratingTableView.dataSource = self
        ratingTableView.allowsSelection = false
        ratingTableView.separatorStyle = .none
        ratingTableView.showsVerticalScrollIndicator = false
        ratingTableView.showsHorizontalScrollIndicator = false
        

        ratingTableView.registerForCell(identifier: RatingAndReviewTableViewCell.identifier)
        ratingTableView.registerForCell(identifier: CommentSectionTableViewCell.identifier)
        ratingTableView.registerForCell(identifier: CommentTableViewCell.identifier)



    }
    
    private func setupViews(){
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Ratings and reviews"
    }
    
    //MARK: Navigation Title
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.isNavigationBarHidden = false

    }

    
}

//MARK: - UITableViewDataSource
extension ReviewsViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = items[indexPath.section]
        switch itemType{
    
        case .RatingAndReviewItemCell:
            let cell =  tableView.dequeueCell(identifier: RatingAndReviewTableViewCell.identifier, indexPath: indexPath) as RatingAndReviewTableViewCell
            cell.ratingClick = true
            return cell
     
        case .RatingListItemCell:
            let cell =  tableView.dequeueCell(identifier: CommentTableViewCell.identifier, indexPath: indexPath) as CommentTableViewCell
            cell.ratingClick = true
            cell.book = book
            cell.delegate = self
            return cell
        case .CommentSectionItemCell:
            let cell =  tableView.dequeueCell(identifier: CommentSectionTableViewCell.identifier, indexPath: indexPath) as CommentSectionTableViewCell
            return cell
       
        }
       
    }
  
    
}

extension ReviewsViewController: OnSetCommentCount{
    func onSetCommentCount(count: Int) {
        self.commentCount = count
    }
}


