//
//  BookRepository.swift
//  LibraryApp
//
//  Created by KC on 16/06/2022.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

protocol BookRepository{
    func saveBookList(data: [BookList])
    func saveMoreBookList(type: String, data: [CategoryResult])
    func saveBookToWishList(id: String, completion: @escaping (LBResult<String>) -> Void)
    func checkBookWishlist(id: String)-> Observable<Bool>
    func removeBookFromWishList(id: String, completion: @escaping (LBResult<String>) -> Void)
    
    func getMoreBookList(type: String) -> Observable<[Book]>
    func getBookList() -> Observable<[BookList]>
    func getBookDetail(id: String )-> Observable<Book>
    func getMoreBookByPagination(page: Int , type: String) -> Observable<[Book]>
    func getTotalPages(type: String ) -> Int
    func saveBookAndAddToWishlist(data: Book)
}

class BookRepositoryImpl: BaseRepository, BookRepository{
    
    static let shared : BookRepository = BookRepositoryImpl()
    
    private let itemsPerPage = 15

    
    private override init() { }
    
    func saveBookList(data: [BookList]) {
        let objects = List<BookListObject>()
        
        data.forEach { item in
            objects.append(BookList.toBookListObject(bookList: item))

        }
        try! realmDB.write {
            realmDB.add(objects, update: .modified)
        }
        
    }
    
 
    
    func saveBookToWishList(id: String, completion: @escaping (LBResult<String>) -> Void) {

        guard let _  = realmDB.object(ofType: WishlistBookObject.self, forPrimaryKey: id) else{
            do{
                let object = WishlistBookObject()
                object.id = id
                object.insertedAt = Date()
                try realmDB.write {
                    realmDB.add(object, update: .modified)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
            return
        }
        
    }
    
    func removeBookFromWishList(id: String, completion: @escaping (LBResult<String>) -> Void) {

        guard let object  = realmDB.object(ofType: WishlistBookObject.self, forPrimaryKey: id) else{
            return
        }
        do{
            try realmDB.write{
                realmDB.delete(object)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func checkBookWishlist(id: String)-> Observable<Bool> {
        guard let _  = realmDB.object(ofType: WishlistBookObject.self, forPrimaryKey: id) else{
            return Observable.just(false)
        }
        return Observable.just(true)
    }
    

    func saveMoreBookList(type: String, data: [CategoryResult]) {
        
//        guard let bookListObject = realmDB.object(ofType: BookListObject.self, forPrimaryKey: type) else {
//            return
//        }
//
//        let result: [BookObject] = data.map { Book.toBookObject(book: ($0.bookDetails?.first)!)}
//        let bookList = List<BookObject>()
//        result.forEach{ bookList.append($0)}
//
//        do {
//            try realmDB.write {
//                realmDB.add(bookList, update: .modified)
//                bookListObject.books = bookList
//            }
//        }catch {
//            print(error.localizedDescription)
//        }
        
        
        let bookList = List<BookObject>()
        guard let bookListObject  = realmDB.object(ofType: BookListObject.self, forPrimaryKey: type) else{
            return
        }

        data.forEach{ item in
            if let book = item.bookDetails?.first {
                guard let object  = realmDB.object(ofType: BookObject.self, forPrimaryKey: book.primaryIsbn10) else{

                    bookList.append(Book.toBookObject(book: book))
                    return
                }


                do{
                    try realmDB.write{
                        object.title = book.title
                        object.bookDescription = book.bookDescription
                        object.contributor = book.contributor
                        object.author = book.author
                        object.contributor = book.contributor
                        object.price = book.price
                        object.ageGroup = book.ageGroup
                        object.primaryIsbn13 = book.primaryIsbn13
                        bookList.append(object)
                    }
                }catch{
                    debugPrint(error.localizedDescription)
                }
            }

        }
        do{
            try realmDB.write {

                if bookList.count > 0{
                    bookListObject.books = bookList
                }
                realmDB.add(bookListObject, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    func saveBookAndAddToWishlist(data: Book) {
        guard let _ =  realmDB.object(ofType: BookObject.self, forPrimaryKey: data.primaryIsbn10) else{
            do{
                let object = Book.toBookObject(book: data)
                try realmDB.write {
                    realmDB.add(object, update: .modified)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
            return
        }
    }
    
    func getBookDetail(id: String )-> Observable<Book>{
        let list: [Book] = realmDB.objects(BookObject.self)
            .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "primaryIsbn10", id))
            .map{ $0.toBook() }
        if let book = list.first{
            //completion(.success(book))
            return Observable.just(book)
        }
        
        return Observable.empty()
            
    }
    
    func getBookList() -> Observable<[BookList]>{
        let realmObjects = realmDB.objects(BookListObject.self)
         return Observable.collection(from:realmObjects)
            .flatMap { (results) -> Observable<[BookListObject]> in
                .just(results.toArray())
            }
            .flatMap { (objects) -> Observable<[BookList]> in
                .just(objects.map { $0.toBookList() })
            }
    }
    
   
    
    
    func getMoreBookList(type: String) -> Observable<[Book]> {
        let items:[BookListObject] = self.realmDB.objects(BookListObject.self)
            .filter("listNameEncoded == %@", type)
            .map{ $0 }
        if let firstItem = items.first{
            return Observable.collection(from: firstItem.books)
                .flatMap { books -> Observable<[Book]> in
                    return Observable.create { (observer) -> Disposable in
                        let items : [Book] = books.map { $0.toBook()

                        }
                        observer.onNext(items)
                        return Disposables.create()
                    }
            }
        }
        return Observable.empty()
        
    }

    
    func getTotalPages(type: String ) -> Int {
        var totalPages =  0
        let items: [BookListObject] = realmDB.objects(BookListObject.self)
            .filter("listNameEncoded == %@", type).map { $0 }
        if let count = items.first?.books.count{
            totalPages = count / itemsPerPage
            if count % itemsPerPage != 0 {
                totalPages += 1
            }
        }
        
       return totalPages
    }
    
    func isLastPage(_ page: Int, _ type: String ) -> Bool {
        return page == getTotalPages(type: type)
    }
    
    func getMoreBookByPagination(page: Int , type: String) -> Observable<[Book]> {
        
        var data = [Book]()
        let startAt = (itemsPerPage * page ) - itemsPerPage
        let endAt = startAt + itemsPerPage
        let objects = realmDB.objects(BookListObject.self)
            .filter("listNameEncoded == %@", type).map{ $0.toBookList()}
        if let items = objects.first?.books{
            if(isLastPage(page, type)){
                data = Array(items.dropFirst((page - 1) * itemsPerPage))
            }
            else{
                data = Array(items[startAt..<endAt])
            }
        }

        
        return Observable.just(data)
               
        
        //https://github.com/realm/realm-swift/issues/3241
    }

}
    

  
    
