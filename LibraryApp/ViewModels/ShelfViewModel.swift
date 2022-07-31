//
//  ShelfViewModel.swift
//  LibraryApp
//
//  Created by KC on 28/06/2022.
//

import Foundation
import Combine
import RxSwift

enum ShelfViewState{
    case sendBookData
}


class ShelfViewModel {
   
    var viewState: PassthroughSubject<ShelfViewState, Never> = .init()
    private let libraryModel :  LibraryModel!
    private let disposeBag = DisposeBag()
    private var bookList: [Book] = []

    var id: String = ""
    var name: String = ""
    
    var bookSortingList : [Book] = []
    var items : [ShelfVCSectionType] = []
    
    var bookItems : [ShelfVCSectionType] = [
        .TitleShelf,
        .SortingAndGrid,
        .WishListBookList
    ]
    var noitems : [ShelfVCSectionType] = [
        .TitleShelf,
    ]
 

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
    
    
    func getBookList(){
        libraryModel.getShelfBookListByID(id: id)
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.bookSortingList = items
                self.bookList = items
                self.sortingBooks()
                
            }).disposed(by: disposeBag)
        

    }
    
  
    
    func setDefaultSortingAndGrid(){
        sorting = UDM.shared.defaults.string(forKey: "sorting") ?? SortingLibrary.recent.rawValue
        viewAs  = UDM.shared.defaults.string(forKey: "view_as") ?? ViewGrid.small.rawValue
        
    }
    
    
 
    
   
}
