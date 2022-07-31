//
//  BookListExtension.swift
//  LibraryApp
//
//  Created by KC on 16/06/2022.
//

import Foundation
import RealmSwift

extension BookList {
    static func toBookListObject(bookList: BookList) -> BookListObject{
        let object = BookListObject()
        
        object.listID = bookList.listID
        
        object.listName = bookList.listName
        
        object.listNameEncoded = bookList.listNameEncoded
        
        object.displayName = bookList.displayName
        
        object.updated = bookList.updated
        
        let books = List<BookObject>()
        bookList.books?.forEach{
            books.append(Book.toBookObject(book: $0))
            
        }
        object.books = books
        
        return object
    }
}


