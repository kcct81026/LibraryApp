//
//  WishlistBookObject.swift
//  LibraryApp
//
//  Created by KC on 23/06/2022.
//

import Foundation
import RealmSwift

class WishlistBookObject : Object {
    
    @Persisted
    var insertedAt : Date?
    
    @Persisted(primaryKey: true)
    var id: String?
    
//    @Persisted(originProperty: "book")
//    var book: LinkingObjects<BookObject>
    
    func toWishlistBook()-> Wishlist{
        return Wishlist(insertedAt: insertedAt, id: id)
    }
}

struct Wishlist{
    var insertedAt: Date?
    var id: String?
    //var book : Book?
}



