//
//  BookDetailViewModle.swift
//  LibraryApp
//
//  Created by KC on 20/06/2022.
//

import Foundation
import Combine
import RxSwift

protocol BookDetailViewModelType{
    func getBookDetail()
}

enum ViewDetailModelState{
    case sendBookDetail(data: Book)
    case addedToWishList
    case removedFromWishList
}

class BookDetailViewModel: BookDetailViewModelType{
    
    var viewState: PassthroughSubject<ViewDetailModelState, Never> = .init()
    
    private let bookModel :  BookModel!
    private let disposeBag = DisposeBag()
    private var id: String = ""
    
    
    var items : [BookDetailViewControllerSectionType] = [
        .BookInfoCell,
        .BookActionSectionCell,
        .BookDetailItemCell,
        .RatingAndReviewItemCell,
        .CommentSectionItemCell,
        .CommentSectionItemCell,
        .CommentSectionItemCell,
        .PublisherCell
    
        
    ]

    init(bookModel : BookModel = BookModelImpl.shared, id: String){
        self.bookModel = bookModel
        self.id = id 
    }
    
    var isAddedBookMark: Bool = false {
        didSet {
            if isAddedBookMark {
                viewState.send(.addedToWishList)
            } else {
                viewState.send(.removedFromWishList)
            }
        }
    }
    
    func getBookDetail() {
        bookModel.getBookDetail(id: id)
            .subscribe(onNext: { [weak self] (result) in
                self?.viewState.send(.sendBookDetail(data: result))
            }).disposed(by: disposeBag)
    }
    
    func toggleTapWishList(){
        if self.isAddedBookMark {
            bookModel.removeBookFromWishList(id: self.id, completion: nil)
        } else {
            bookModel.saveBookToWishList(id: self.id, completion: nil)
        }
        
        self.isAddedBookMark.toggle()
    }
    
    func checkWatchList(){
        bookModel.checkBookWishlist(id: self.id)
            .subscribe(onNext: { [weak self] data in
                self?.isAddedBookMark = data
            })
            .disposed(by: disposeBag)
    }
    
    
    
}


