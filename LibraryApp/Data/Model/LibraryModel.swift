//
//  LibraryModel.swift
//  LibraryApp
//
//  Created by KC on 23/06/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Realm

protocol LibraryModel {
    func getLibraryBookList(sorting: String) -> Observable<[Book]>
   // func getShelvesList() -> Observable<[MyShelves]>
    func saveShelf(name: String,  completion: @escaping  (Bool) -> Void)
    func editShelf(id: String, updated: String , completion: @escaping  (Bool) -> Void)
    func getShelfBookListByID(id:String)-> Observable<[Book]>
    func addBookToShelf(shelfid: String, bookId: String)
    func getWishListBooks() -> Observable<[Book]>
    func getShelfList() -> Observable<[MyShelves]>
    func deleteShelf(id: String, completion: @escaping  (Bool) -> Void)
    func getShelfByID(id:String)-> Observable<MyShelves>
    func checkBookInLibrary(bookId:String, completion: @escaping  (Bool) -> Void)

}

class LibraryModelImpl: BaseModel, LibraryModel {
  
    
    static let shared : LibraryModel = LibraryModelImpl()

    private override init() { }
    
    private let libraryRepository : LibraryRepository = LibraryRepositoryImpl.shared
    
    func saveShelf(name: String, completion: @escaping  (Bool) -> Void) {
        libraryRepository.saveShelf(name: name) { (results) in
            completion(results)
        }
    }
    
    func getWishListBooks() -> Observable<[Book]> {
        return libraryRepository.getWishListBooks()
    }
    
    func getLibraryBookList(sorting: String) -> Observable<[Book]> {
        return libraryRepository.getLibraryBookList(sorting: sorting)
    }

    func getShelfList() -> Observable<[MyShelves]>{
        return libraryRepository.getShelfList()
    }
    
    func editShelf(id: String, updated: String ,  completion: @escaping  (Bool) -> Void){
    
        libraryRepository.editShelf(id: id, updated: updated){ (results) in
            completion(results)
        }
    }
    
    func addBookToShelf(shelfid: String, bookId: String) {
        libraryRepository.addBookToShelf(shelfid: shelfid, bookId: bookId)
    }
    
    func getShelfBookListByID(id: String) -> Observable<[Book]> {
        return libraryRepository.getShelfBookListByID(id: id)
    }
    
    func deleteShelf(id: String, completion: @escaping  (Bool) -> Void){
        libraryRepository.deleteShelf(id: id){ (results) in
            completion(results)
            
        }
    }
    
    func getShelfByID(id:String)-> Observable<MyShelves>{
        libraryRepository.getShelfByID(id: id)
    }
    
    func checkBookInLibrary(bookId:String, completion: @escaping  (Bool) -> Void){
        libraryRepository.checkBookInLibrary(bookId: bookId){ result in
            completion(result)
        }
    }
    
    
}

