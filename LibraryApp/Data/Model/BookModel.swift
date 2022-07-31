//
//  BookHomeModel.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//


import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Realm

protocol BookModel {
   
    func getOverviewBookList() -> Observable<[BookList]>
    func getMoreBooks(type:String, offset: Int) -> Observable<[Book]>
    func getBookDetail(id: String )-> Observable<Book>
    func getTotalPages(type: String) -> Int
    func getMoreBooksByPaganation(type:String, offset: Int) -> Observable<[Book]>
    
    func saveBookToWishList(id: String, completion: ((LBResult<String>) -> Void)?)
    func saveBookAndAddToWishlist(data: Book)
    func removeBookFromWishList(id: String, completion: ((LBResult<String>) -> Void)?)
    func checkBookWishlist(id: String) -> Observable<Bool> 
}

class BookModelImpl: BaseModel, BookModel {
   
   
    static let shared : BookModel = BookModelImpl()

    private override init() { }
    
    private let bookRepository : BookRepository = BookRepositoryImpl.shared

    let disposeBag = DisposeBag()
    
    func saveBookToWishList(id: String, completion: ((LBResult<String>) -> Void)?) {
        bookRepository.saveBookToWishList(id: id) { (results) in
            completion?(results)
        }
    }
    
    func removeBookFromWishList(id: String, completion: ((LBResult<String>) -> Void)?) {
        bookRepository.removeBookFromWishList(id: id) { (results) in
            completion?(results)
        }
    }
    
    
    func checkBookWishlist(id: String) -> Observable<Bool> {
        return bookRepository.checkBookWishlist(id: id)
    }
    
    
    func getOverviewBookList() -> Observable<[BookList]>  {
        
        let observableBookList = RxNetworkAgent.shared.getOverViewList()
        observableBookList
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if let data = result.results?.lists{
                    self.bookRepository.saveBookList(data: data )

                }
                
            })
            .disposed(by: disposeBag)
        
        let observableLocalBookList = bookRepository.getBookList()
        return observableLocalBookList

    }
    
    func getMoreBooks(type:String, offset: Int) -> Observable<[Book]> {
        
        let observableBookList = RxNetworkAgent.shared.getMoreBookList(type: type, offset: offset)
        observableBookList
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let data = result.results{
                    self.bookRepository.saveMoreBookList(type: type, data: data )

                }

            })
            .disposed(by: disposeBag)

        let observableLocalBookList = bookRepository.getMoreBookList(type: type)
        return observableLocalBookList
        
    
    }
    
    func saveBookAndAddToWishlist(data: Book){
        bookRepository.saveBookAndAddToWishlist(data: data)
    }
    
    func getBookDetail(id: String) -> Observable<Book> {
        return bookRepository.getBookDetail(id: id)
    }
    
    func getMoreBooksByPaganation(type:String, offset: Int) -> Observable<[Book]> {
        
        let observableBookList = RxNetworkAgent.shared.getMoreBookList(type: type, offset: (offset - 1))
        observableBookList
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
               // networkResult = result.results ?? []
                if let data = result.results{
                    self.bookRepository.saveMoreBookList(type: type, data: data )
                }

            })
            .disposed(by: disposeBag)
        
        
//        let observableLocalBookList = bookRepository.getMoreBookByPagination(page: offset, type: type)
//        return observableLocalBookList
        let observableLocalBookList = bookRepository.getMoreBookList(type: type)
        return observableLocalBookList

        
    
    }
    private var totalPages = 0
    
    func getTotalPages(type: String) -> Int {
        return self.bookRepository.getTotalPages(type: type)

    }

}
