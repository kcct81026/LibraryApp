//
//  BookListObject.swift
//  LibraryApp
//
//  Created by KC on 15/06/2022.
//

import Foundation
import RealmSwift

class BookListObject : Object {
    
    @Persisted
    var listID: Int?
    @Persisted
    var listName: String?
    @Persisted(primaryKey: true)
    var listNameEncoded: String?
    @Persisted
    var displayName: String?
    @Persisted
    var updated: String?
    @Persisted
    var books: List<BookObject>
    
    func toBookList() -> BookList {
        let allBooks:[Book] = books.map{
            $0.toBook()
        }
        
        return BookList(listID: listID, listName: listName, listNameEncoded: listNameEncoded, displayName: displayName, updated: updated, listImage: nil, listImageWidth: nil, listImageHeight: nil, books: allBooks)
    }
}
