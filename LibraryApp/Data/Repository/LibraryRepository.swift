//
//  LibraryRepository.swift
//  LibraryApp
//
//  Created by KC on 23/06/2022.

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import SwiftUI

protocol LibraryRepository{
    
    func getLibraryBookList(sorting: String) -> Observable<[Book]>
  
    func saveShelf(name: String, completion: @escaping  (Bool) -> Void)
    func editShelf(id: String, updated: String , completion: @escaping  (Bool) -> Void)
    func addBookToShelf(shelfid: String, bookId: String)
    func getWishListBooks() -> Observable<[Book]>
    func getShelfList() -> Observable<[MyShelves]>
    func getShelfBookListByID(id:String)-> Observable<[Book]>
    func deleteShelf(id: String, completion: @escaping  (Bool) -> Void)
    func getShelfByID(id:String)-> Observable<MyShelves>
    func checkBookInLibrary(bookId:String, completion: @escaping  (Bool) -> Void)
    
}

class LibraryRepositoryImpl: BaseRepository, LibraryRepository{
   
    
    static let shared : LibraryRepository = LibraryRepositoryImpl()
    
    private override init() { }
    let disposeBag = DisposeBag()
    
    func saveShelf(name: String,  completion: @escaping  (Bool) -> Void) {
        
        let item = realmDB.objects(ShelvesObject.self).filter(NSPredicate(format: "shelfName = %@",  name))
        if item.count == 0 {
            do{
                let object = ShelvesObject()
                object.id = String.random(length: 8)
                object.shelfName = name
                try realmDB.write {
                    realmDB.add(object, update: .modified)
                }
                completion(true)
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        else{
            completion(false)
        }
        

    }
    
    
    func editShelf(id: String, updated: String ,  completion: @escaping  (Bool) -> Void){
        guard let object  = realmDB.object(ofType: ShelvesObject.self, forPrimaryKey: id ) else{
            return completion(false)
        }
        do{
            try realmDB.write {
                object.shelfName = updated
                realmDB.add(object, update: .modified)
            }
            completion(true)
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteShelf(id: String, completion: @escaping  (Bool) -> Void){
        guard let object  = realmDB.object(ofType: ShelvesObject.self, forPrimaryKey: id ) else{
            return completion(false)
        }
        
        let items = realmDB.objects(ShelfIdObject.self).filter(NSPredicate(format: "shelfId = %@",  id))
        do{
            try realmDB.write {
                realmDB.delete(object)
                realmDB.delete(items)
            }
            completion(true)
        }catch{
            debugPrint(error.localizedDescription)
        }
        
        
    }
    
    private func getShelfBooks(id:String)-> [Book]{
        var bookItems : [Book] = []
        self.getShelfBookListByID(id: id)
            .subscribe(onNext:{ result in
                bookItems = result
                
            }).disposed(by: disposeBag)
//        let items = realmDB.objects(ShelfIdObject.self).filter(NSPredicate(format: "%K = %@", "shelfId", id))
//            .map { $0 }
//        bookItems = items.map { $0.bookId}
//            .flatMap { id in
//                realmDB.objects(BookObject.self)
//                    .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "primaryIsbn10", id))
//                    .map{ $0.toBook() }
//            }
//
        return bookItems

    }
    
    func getShelfByID(id:String)-> Observable<MyShelves>{
        let object  = realmDB.object(ofType: ShelvesObject.self, forPrimaryKey: id )
        return Observable.just( object?.toMyShelves(books: [Book]()) ?? MyShelves.empty() )
    }
    
    func checkBookInLibrary(bookId:String, completion: @escaping  (Bool) -> Void){
        guard let _ = realmDB.object(ofType: WishlistBookObject.self, forPrimaryKey: bookId ) else {
            return completion(false)
        }
        completion(true)
        
    }
    
    func getShelfList() -> Observable<[MyShelves]>{
        let realmObjects = realmDB.objects(ShelvesObject.self)

         return Observable.collection(from:realmObjects)
            .flatMap { (results) -> Observable<[ShelvesObject]> in
                .just(results.toArray())
            }
            .flatMap { (objects) -> Observable<[MyShelves]> in
            .just(objects.map { $0.toMyShelves(books: self.getShelfBooks(id: $0.id)) })
            }
    }
    
    func getShelfBookListByID(id:String)-> Observable<[Book]>{
                
        let realmObjects = realmDB.objects(ShelfIdObject.self)
            .filter(NSPredicate(format: "%K = %@", "shelfId", id))

         return Observable.collection(from:realmObjects)
            .flatMap { (results) -> Observable<[ShelfIdObject]> in
                .just(results.toArray())
            }
            .flatMap { (objects) -> Observable<[Book]> in
                .just(objects.map { $0.bookId }
                .flatMap{ id in
                    self.realmDB.objects(BookObject.self)
                        .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "primaryIsbn10", id))
                        .map{ $0.toBook() }
                })
            }
    }
    
    
    func addBookToShelf(shelfid: String, bookId: String){
      

        let predict2 = NSPredicate.init(format: "bookId == %@", bookId)
        let predict = NSPredicate.init(format: "shelfId == %@", shelfid)

        let query = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predict,predict2])
        guard let object = realmDB.objects(ShelfIdObject.self).filter(query).first else{
            saveBookToShelf(id: shelfid, bookId: bookId)
            return
        }
        do{
            try realmDB.write {
                object.bookId = bookId
                object.shelfId = shelfid
                realmDB.add(object, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    private func saveBookToShelf(id:String, bookId: String){
        do{
            try realmDB.write {
                let object = ShelfIdObject()
                object.bookId = bookId
                object.shelfId = id
                realmDB.add(object, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }

 
    func getLibraryBookList(sorting: String) -> Observable<[Book]> {
        let items:[WishlistBookObject] = self.realmDB.objects(WishlistBookObject.self)
            .sorted(byKeyPath: "insertedAt", ascending: false)
            .map{ $0 }

        var bookItems : [Book] = []
        bookItems = items.map { $0.id ?? ""}
            .flatMap { id in
                realmDB.objects(BookObject.self)
                    .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "primaryIsbn10", id))
                    .map{ $0.toBook() }
            }
        
        if sorting == SortingLibrary.title.rawValue {
            bookItems = bookItems.sorted(by:({ (first, second) -> Bool in
                return first.title?.caseInsensitiveCompare(second.title ?? "") == .orderedAscending
            }))
        }
        else if sorting == SortingLibrary.author.rawValue{
            bookItems = bookItems.sorted(by:({ (first, second) -> Bool in
                return first.author!.caseInsensitiveCompare(second.author ?? "") == .orderedAscending
            }))
        }
        

        return Observable.just(bookItems)

    }
    
    func getWishListBooks() -> Observable<[Book]>{
        let realmObjects = realmDB.objects(WishlistBookObject.self)
            .sorted(byKeyPath: "insertedAt", ascending: false)
        
        return Observable.collection(from:realmObjects)
            .flatMap { (results) -> Observable<[WishlistBookObject]> in
                .just(results.toArray())
            }
            .flatMap { (objects) -> Observable<[Book]> in
                .just(objects.map { $0 }
                        .map { $0.id ?? ""}
                        .flatMap { id in
                            self.realmDB.objects(BookObject.self)
                                .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "primaryIsbn10", id))
                                .map{ $0.toBook() }
                                
                        }
                )
            }
            
    }
    
    
    
 
}
    
    
   
        
            
    
       
    
  
    

    

  
    

