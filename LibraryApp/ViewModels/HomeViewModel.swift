//
//  HomeViewModel.swift
//  LibraryApp
//
//  Created by KC on 17/06/2022.
//

import Foundation
import Combine
import RxSwift

enum HomeViewState{
    case sendBookList
    case sendAudioBookList
    case sendSliderBookList
}




class HomeViewModel : HomeViewModelType{
   
    var viewState: PassthroughSubject<HomeViewState, Never> = .init()
    private let bookModel :  BookModel!
    private let disposeBag = DisposeBag()
    
    var items : [HomeViewControllerSectionType] = [
        .SearchBook,
        .BookListSlider,
        .TabTableView,
        .CategoryList,
        
    ]
    
    var bookList : [BookList] = []
    var sliderBooks : BookList!

    init(bookModel : BookModel = BookModelImpl.shared){
        self.bookModel = bookModel
    }
    
    func getEbookList() {
        bookModel.getOverviewBookList()
            .subscribe(onNext:{ [weak self] (data) in
                guard let self = self else { return }
                self.bookList = data

                self.viewState.send(.sendBookList)
                
                
            })
            .disposed(by: disposeBag)
    }
    
    func getSliderBookList() {
        bookModel.getOverviewBookList()
            .subscribe(onNext:{ [weak self] (result) in
                guard let self = self else { return }
                if let data = result.last{
                    self.sliderBooks = data
                    self.viewState.send(.sendSliderBookList)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func getAudioList() {
        bookModel.getOverviewBookList()
            .subscribe(onNext:{ [weak self] (result) in
                guard let self = self else { return }
                if result.count > 0 {
                    var test: [BookList] = [BookList]()
                    test.append(result.last!)
                    self.bookList = test

                    self.viewState.send(.sendAudioBookList)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
