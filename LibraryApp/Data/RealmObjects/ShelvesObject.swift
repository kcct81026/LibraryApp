//
//  ShelvesObject.swift
//  LibraryApp
//
//  Created by KC on 24/06/2022.
//

import Foundation
import RealmSwift

class ShelvesObject: Object{
    
    @Persisted(primaryKey: true)
    var id : String
    
    @Persisted
    var shelfName: String?

    
    func toMyShelves(books: [Book])-> MyShelves{
        
        return MyShelves(id: id, shelfName: shelfName, books: books)
    }
}
struct MyShelves {
    var id: String
    var shelfName: String?
    var books: [Book]?
    
    static func empty()-> MyShelves{
        return MyShelves(id: "", shelfName: "", books: [])
    }
    
    
}

class MyShelvesVO{
    
    var id: String
    var shelfName: String
    var books: [Book]
    var alreadyAdded: Bool
    var isSelected: Bool
    
    internal init(id: String, shelfName: String, books: [Book] = [], isSelected: Bool = false, alreadyAdded: Bool = false  ) {
        self.id = id
        self.shelfName = shelfName
        self.books = books
        self.isSelected = isSelected
        self.alreadyAdded = alreadyAdded
        
    }
    
   
    
}
