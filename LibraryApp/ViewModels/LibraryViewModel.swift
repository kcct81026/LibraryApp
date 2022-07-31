//
//  LibraryViewModel.swift
//  LibraryApp
//
//  Created by KC on 23/06/2022.
//


import Foundation
import Combine
import RxSwift
import RxCocoa



enum LibraryViewState{
    case sendShelvesData
    case sendBookData
}


class LibraryViewModel {
    
    var items: [LibraryVCSectionType] = []
    
    var booksItems : [LibraryVCSectionType] = [
        .SearchBook,
        .TabTableView,
        .SortingAndGrid,
        .WishListBookList
        
    ]
    
    var noshelves: [LibraryVCSectionType] = [
        .SearchBook,
        .TabTableView
    ]
    
    var shelfItems : [LibraryVCSectionType] = [
        .SearchBook,
        .TabTableView,
        .ShelvesList,
        
    ]
   
    var viewState: PassthroughSubject<LibraryViewState, Never> = .init()
    private let libraryModel :  LibraryModel!
    private let disposeBag = DisposeBag()
    
    var shelvesList : [MyShelves] = []
    var bookSortingList : [Book] = []
    private var bookList: [Book] = []


    var sorting : String = ""{
        didSet{
            sortingBooks()
        }
    }
    
    var viewAs: String = "" {
        didSet{
            viewState.send(.sendBookData)
        }
    }

    init(libraryModel : LibraryModel = LibraryModelImpl.shared){
        self.libraryModel = libraryModel
       
    }
    
    func sortingBooks(){
        if sorting == SortingLibrary.title.rawValue {
            bookSortingList = bookSortingList.sorted(by:({ (first, second) -> Bool in
                return first.title?.caseInsensitiveCompare(second.title ?? "") == .orderedAscending
            }))
        }
        else if sorting == SortingLibrary.author.rawValue{
            bookSortingList = bookSortingList.sorted(by:({ (first, second) -> Bool in
                return first.author!.caseInsensitiveCompare(second.author ?? "") == .orderedAscending
            }))
        }
        else{
            bookSortingList = bookList
        }
        viewState.send(.sendBookData)
       
    }
    
    func getWishListBooks(){
        UDM.shared.defaults.set(TapBooksAndShelves.book.rawValue, forKey: "tap")
        libraryModel.getWishListBooks()
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.bookSortingList = items
                self.bookList = items
                self.sortingBooks()
                
            }).disposed(by: disposeBag)
    }
    
  
    
    func getShelvesList(){
        UDM.shared.defaults.set(TapBooksAndShelves.shelf.rawValue, forKey: "tap")
        libraryModel.getShelfList()
            .subscribe(onNext: {  [weak self ] data in
                guard let self = self else { return }
                self.shelvesList = data
                self.viewState.send(.sendShelvesData)
        }).disposed(by: disposeBag)
    }
    
    func setDefaultSortingAndGrid(){
        sorting = UDM.shared.defaults.string(forKey: "sorting") ?? SortingLibrary.recent.rawValue
        viewAs  = UDM.shared.defaults.string(forKey: "view_as") ?? ViewGrid.small.rawValue
    }
    
    
 
    
   
}

