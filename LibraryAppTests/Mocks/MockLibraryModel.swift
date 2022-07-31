//
//  MockLibraryModel.swift
//  LibraryAppTests
//
//  Created by KC on 06/07/2022.
//

import Foundation
import RxSwift
@testable import LibraryApp

class MockLibraryModel : LibraryModel {
    var noShlefList : Bool = false
    var noWishlistBook : Bool = false
    
    var myShlefList : [MyShelves] = []
    var myWishListBookList : [Book] = []
    
    init(){
        myShlefList = [
            MyShelves(id: "abcd", shelfName: "Test1", books: []),
            MyShelves(id: "abcde", shelfName: "Test2", books: []),

        ]
        
        myWishListBookList = [
            Book.dummy(),
            Book.dummy(),
        ]
    }
    func getLibraryBookList(sorting: String) -> Observable<[Book]> {
        Observable.empty()
    }
    
    func saveShelf(name: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func editShelf(id: String, updated: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func getShelfBookListByID(id: String) -> Observable<[Book]> {
        Observable.empty()
    }
    
    func addBookToShelf(shelfid: String, bookId: String) {
        
    }
    
    func getWishListBooks() -> Observable<[Book]> {
        if noWishlistBook {
            return Observable.just([])
        }else{
            return Observable.just(myWishListBookList)
        }
    }
    
    func getShelfList() -> Observable<[MyShelves]> {
        if noShlefList {
            return Observable.just([])
        }else{
            return Observable.just(myShlefList)
        }
    }
    
    func deleteShelf(id: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func getShelfByID(id: String) -> Observable<MyShelves> {
        Observable.empty()
    }
    
    func checkBookInLibrary(bookId: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    
}
