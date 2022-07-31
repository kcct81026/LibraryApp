//
//  ShelfListViewModel.swift
//  LibraryApp
//
//  Created by KC on 29/06/2022.
//

import Foundation
import Combine
import RxSwift
import SwiftUI

enum ShelfListViewState{
    case sendShelvesData
    case sendAddedAlert
    case noItemAdded
}



class ShelfListViewModel {
   
    var viewState: PassthroughSubject<ShelfListViewState, Never> = .init()
    private let libraryModel :  LibraryModel!
    private let bookModel :  BookModel!
    private let disposeBag = DisposeBag()
    
    var shelvesList : [MyShelves] = []
    var shelfIds : [String] = []
    var checkShelveList : [MyShelvesVO] = []



    init(libraryModel : LibraryModel = LibraryModelImpl.shared, bookModel: BookModel = BookModelImpl.shared){
        self.libraryModel = libraryModel
        self.bookModel = bookModel
       
    }
   
    func getShelvesList(id: String){
        libraryModel.getShelfList()
            .subscribe(onNext: {  [weak self ] data in
                guard let self = self else { return }
                self.shelvesList = data
                self.checkList(id: id)
        }).disposed(by: disposeBag)
    }
    
    func savingDataShelfList(){
        self.shelfIds.removeAll()
        self.checkShelveList.forEach{
            if $0.isSelected {
                shelfIds.append($0.id)

            }
        }
        self.viewState.send(.sendShelvesData)
    }
    
    func addBookToShelves(bookId: String){
        if shelfIds.isEmpty {
            viewState.send(.noItemAdded)
        }
        else{
            shelfIds.forEach{ id in
               libraryModel.addBookToShelf(shelfid: id , bookId: bookId)
            }
            viewState.send(.sendAddedAlert)
        }
       
        
        
    }
    
  
    private func checkList(id: String){
        for (_, item) in shelvesList.enumerated() {
            if (item.books?.count ?? 0) > 0 {
                var temp = false
                for i in 0 ..< item.books!.count{
                    if item.books![i].primaryIsbn10 == id {
                        temp = true
                    }
                    
                   
                }

                checkShelveList.append(MyShelvesVO(id: item.id, shelfName: item.shelfName ?? "", books: item.books ?? [Book](), isSelected: temp, alreadyAdded: temp))
                
            }
            else{
                checkShelveList.append(MyShelvesVO(id: item.id, shelfName: item.shelfName ?? "", books: [], isSelected: false, alreadyAdded: false))
            }
        }
        
        
        
        self.viewState.send(.sendShelvesData)

        
    }
   
}


