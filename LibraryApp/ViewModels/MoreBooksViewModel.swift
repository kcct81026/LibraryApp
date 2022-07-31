//
//  MoreBooksViewModel.swift
//  LibraryApp
//
//  Created by KC on 17/06/2022.
//

import Foundation
import Combine
import RxSwift

protocol MoreBooksViewModelType{
    func fetchBooks(offset: Int)
}

enum MoreBooksViewState{
    case sendMoreBooks

}

class MoreBooksViewModel : MoreBooksViewModelType{
       
    var viewState: PassthroughSubject<MoreBooksViewState, Never> = .init()
    
    // property
    let itemSpacing : CGFloat = 10
    let numberOfItemsPerRow = 2
    var currentPage : Int = 1
    var totalPages : Int = 1
    var data : [Book] = []
    
    private let bookModel :  BookModel!
    private let disposeBag = DisposeBag()
    
    
    var type: String = ""
    var categoryName: String = ""

    
   
    init(bookModel : BookModel = BookModelImpl.shared){
        self.bookModel = bookModel
    }
    
  
    func fetchBooks( offset: Int){
        
        bookModel.getMoreBooks(type: type, offset: offset)
            .subscribe(onNext:{ [weak self] (data) in
                guard let self = self else { return }
                self.data = data
                self.viewState.send(.sendMoreBooks)
                
            })
            .disposed(by: disposeBag)
    }
   
    func fetchBooksByPage(){

        bookModel.getMoreBooksByPaganation(type: type, offset: self.currentPage)
            .subscribe(onNext:{ [weak self] (data) in
                guard let self = self else { return }
                self.data = data
                self.viewState.send(.sendMoreBooks)

            })
            .disposed(by: disposeBag)
    }
    
    func handlePaganation(index: IndexPath, type: String){
        
        let isAtLastRow = index.row == (self.data.count - 1)
        let haveMorePage = self.currentPage < self.totalPages
        if isAtLastRow && haveMorePage{
            self.currentPage = self.currentPage + 1
            self.fetchBooksByPage()
        }
    }
    
}
