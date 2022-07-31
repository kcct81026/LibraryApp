//
//  ShelfBottomDialogViewModel.swift
//  LibraryApp
//
//  Created by KC on 28/06/2022.
//

import Foundation
import RxSwift
import Combine

protocol ShelfBottomDialogViewModelType{
    func deleteBookShelf(id: String)
    func getShelfBookByID(id:String)
}

enum ShelfSelectLayoutViewState{
    case sendDeleteAlert(result: Bool)
    case sendShelfData

}

class ShelfBottomDialogViewModel : ShelfBottomDialogViewModelType{
    
       
    var viewState: PassthroughSubject<ShelfSelectLayoutViewState, Never> = .init()
    
    private let libraryModel :  LibraryModel!
    private let disposeBag = DisposeBag()
    var myShelf : MyShelves?

    
    var id : String = ""

    init(libraryModel : LibraryModel = LibraryModelImpl.shared){
        self.libraryModel = libraryModel
    }
    
    func getShelfBookByID(id: String) {
        libraryModel.getShelfByID(id: id)
            .subscribe(onNext: {  [weak self ] data in
                guard let self = self else { return }
                self.myShelf = data
                self.viewState.send(.sendShelfData)
        }).disposed(by: disposeBag)
    }
    
    
    
    func deleteBookShelf(id: String){
        
        libraryModel.deleteShelf(id: id){ [weak self] result in
            guard let self = self else { return }
            self.viewState.send(.sendDeleteAlert(result:result))
        }
    
    }
    
    
}
