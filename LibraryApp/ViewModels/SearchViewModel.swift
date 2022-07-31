//
//  SearchViewModel.swift
//  LibraryApp
//
//  Created by KC on 20/06/2022.
//
import Foundation
import Combine
import RxSwift

class SearchViewModel{
   
    
    // property
    let itemSpacing : CGFloat = 10
    let numberOfItemsPerRow = 1
    var currentPage : Int = 1
    var totalPage : Int = 1
    
    let searchResultItems : BehaviorSubject<[SearchBookResult]> = BehaviorSubject(value: [])
    
    let disposeBag = DisposeBag()
    
    let networkAgent: RxNetworkAgentProtocol!
    
    init(networkAgent: RxNetworkAgentProtocol = RxNetworkAgent.shared){
        self.networkAgent = networkAgent
    }
    
    func handlePaganation(index: IndexPath, searchText: String){
        let totalItems = try! self.searchResultItems.value().count
        let isAtLastRow = index.row == totalItems - 1
        let hasMorePages = self.currentPage < self.totalPage
        if (isAtLastRow && hasMorePages){
            self.currentPage += 1
            self.searchMovies(keyword: searchText, page: self.currentPage)
        }
    }

    func handleSearchInputText(text: String){
        if text.isEmpty {
            self.currentPage = 1
            self.totalPage = 1
            self.searchResultItems.onNext([])
        } else {
            self.searchMovies(keyword: text, page: self.currentPage)
        }
    }
    
    func searchMovies(keyword: String, page : Int){
        networkAgent.getSearchBookResult(query: keyword, page: page)
            .do(onNext: { item in
                self.totalPage = item.totalItems ?? 1
            })
                .compactMap { $0.items }
            .subscribe(onNext: { item in
                if self.currentPage == 1 {
                    self.searchResultItems.onNext(item)
                } else {
                    self.searchResultItems.onNext(try! self.searchResultItems.value() + item)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func saveBookAndAddToWishlist(data: Book){
        BookModelImpl.shared.saveBookAndAddToWishlist(data: data)
    }
  
    
}
