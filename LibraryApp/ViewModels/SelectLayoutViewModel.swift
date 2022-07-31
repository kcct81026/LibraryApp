//
//  SelectLayoutViewModel.swift
//  LibraryApp
//
//  Created by KC on 17/06/2022.
//

import Foundation
import Combine
import RxSwift


protocol SelectLayoutViewModelType{
    func checkBookInLibrary()
    func getBookDettail()
}

enum SelectLayoutViewState{
    case sendBookDetail(book: Book)
    case sendBookLibraryCheck(alreadySaved: Bool)
    case deletedAction
    case savedToWishlist

}

class SelectLayoutViewModel : SelectLayoutViewModelType{
       
    var viewState: PassthroughSubject<SelectLayoutViewState, Never> = .init()
    
    private let bookModel :  BookModel!
    private let libraryModel : LibraryModel!
    private let disposeBag = DisposeBag()

    var id : String = ""

   
    init(bookModel : BookModel = BookModelImpl.shared, libraryModel: LibraryModel = LibraryModelImpl.shared){
        self.bookModel = bookModel
        self.libraryModel = libraryModel
        
    }
    
  
    func getBookDettail() {
        bookModel.getBookDetail(id: self.id)
            .subscribe(onNext:{ [weak self] (data) in
                guard let self = self else { return }
                self.viewState.send(.sendBookDetail(book: data))
                
            })
            .disposed(by: disposeBag)
    }
    
    func checkBookInLibrary(){
        libraryModel.checkBookInLibrary(bookId: self.id){ [weak self] (data) in
            guard let self = self else { return }
            self.viewState.send(.sendBookLibraryCheck(alreadySaved: data))

        }
    }
    
    func deleteFromLibrary(){
        bookModel.removeBookFromWishList(id: id, completion: nil)
        self.viewState.send(.deletedAction )
    }
    
    
    func addToWishList(){
        bookModel.saveBookToWishList(id: id, completion: nil)
        self.viewState.send(.savedToWishlist)
    }
   
    
    
}
