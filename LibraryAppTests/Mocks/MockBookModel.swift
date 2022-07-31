//
//  RxBookModel.swift
//  LibraryAppTests
//
//  Created by KC on 04/07/2022.
//

import Foundation
@testable import LibraryApp
import RxSwift

class MockBookModel : BookModel{
    
    var bookList : [BookList] = []

    
    init(){
  
        let bookDataJSON : Data = try! Data(contentsOf: LibraryMockData.BookCategoryResult.bookCategoryResultJSONUrl)
        let responseData = try! JSONDecoder().decode(BookListResponse.self, from: bookDataJSON)
        bookList = responseData.results?.lists ?? []
    }
    
    
    func getOverviewBookList() -> Observable<[BookList]> {
        Observable.just(bookList)
    }
    
    func getMoreBooks(type: String, offset: Int) -> Observable<[Book]> {
        Observable.empty()
    }
    
    func getBookDetail(id: String) -> Observable<Book> {
        Observable.empty()
    }
    
    func getTotalPages(type: String) -> Int {
        return 0
    }
    
    func getMoreBooksByPaganation(type: String, offset: Int) -> Observable<[Book]> {
        Observable.empty()
    }
    
    func saveBookToWishList(id: String, completion: ((LBResult<String>) -> Void)?) {
    }
    
    func saveBookAndAddToWishlist(data: Book) {
        
    }
    
    func removeBookFromWishList(id: String, completion: ((LBResult<String>) -> Void)?) {
    }
    
    func checkBookWishlist(id: String) -> Observable<Bool> {
        Observable.empty()
    }
    
    
}
